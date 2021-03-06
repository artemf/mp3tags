require 'open-uri'
require 'mp3info'

module Processable
  extend ActiveSupport::Concern

  def extract_audio_info_async
    self.update!({ processing: true, error: nil, info: nil })
    self.delay.extract_audio_info
  end

  def extract_audio_info
    self.update({ processing: true, error: nil, info: nil })
    begin
      open(self.url, 'rb') do |external|
        Mp3Info.open(external, {parse_mp3: false}) do |mp3|
          self.update!({ info: mp3info_to_hash(mp3).to_json })
        end
      end
    rescue => e
      self.update({ error: e.inspect, info: nil })
      Rails.logger.error e.inspect
      Rails.logger.error e.backtrace
      raise
    ensure
      self.update({ processing: false })
    end
  end

  def mp3info_to_hash(mp3)
    result = {}
    result[:pictures] = extract_pictures(mp3)
    result[:tags1] = mp3.tag1.dup || {}
    result[:tags2] = mp3.tag2.dup || {}
    result[:tags2]['APIC'] = '<picture present>' if result[:tags2].has_key?('APIC')
    result[:tags2]['PIC'] = '<picture present>' if result[:tags2].has_key?('PIC')
    [:tags1, :tags2].each do |t|
      section = result[t]
      section.each do |key,value|
        begin
          section[key] = value.dup.to_s.encode('UTF-8', {invalid: :replace, undef: :replace, replace: '?' })
        rescue
          section[key] = '<binary>'
        end
      end
    end
    result
  end

  def extract_pictures(mp3)
    result = []
    pictures = mp3.tag2.pictures
    pictures.each do |description, data|
      result << Picture.new(description, data, self).url
    end
    result
  end
end