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
    respond_to do |format|
      format.html do
        if @audio_file.processing
          render action: 'processing'
        elsif @audio_file.info
          @info = JSON.parse(@audio_file.info)
          @tags = @info.dup
          @tags.delete('pictures')
          @tags2 = @info['tags2'].dup
          @pictures = @info['pictures'] || []
          @info['tags2'].keys.each do |key|
            if ID3v2::TAGS.has_key? key
              name = ID3v2::TAGS[key]
              value = @info['tags2'][key]
              @info['tags2'].delete(key)
              @info['tags2'][name] = value
            end
          end
          render action: 'info'
        elsif @audio_file.error
          render action: 'error'
        else
          redirect_to root_path
        end
      end
      format.json { render action: 'processing' }
    end
  end

  private

  def set_audio_file
    @audio_file = AudioFile.find(params[:id])
  end

end
