class AudioFile < ActiveRecord::Base
  include Processable

  validates_presence_of :url
end
