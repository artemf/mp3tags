class AudioFilesController < ApplicationController

  before_action :set_audio_file, only: [:show]

  def new
    #@audio_file = AudioFile.new
  end

  def create
    url = params.require('mp3url')
    audio = AudioFile.create!({ url: url })
    audio.extract_audio_info_async
    redirect_to audio_file_path(audio)
  end

  def show
  end

  private

  def set_audio_file
    @audio_file = AudioFile.find(params[:id])
  end

end
