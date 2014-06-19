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
        Mp3Info.open(external) do |mp3|
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
    result = {
        #tags: mp3.tag.dup || {},
        tags1: mp3.tag1.dup || {},
        tags2: mp3.tag2.dup || {}
    }
    result[:tags]['APIC'] = 'Picture present' if result[:tags].has_key?('APIC')
    result[:tags]['PIC'] = 'Picture present' if result[:tags].has_key?('PIC')
    [:tags, :tags1, :tags2].each do |t|
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
end