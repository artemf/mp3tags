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
    {
        title: mp3.tag.title,
        artist: mp3.tag.artist,
        album: mp3.tag.album,
        album_artist: mp3.tag.album_artist,
        composer: mp3.tag.composer
    }
  end
end