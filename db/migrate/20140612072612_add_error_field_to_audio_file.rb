class AddErrorFieldToAudioFile < ActiveRecord::Migration
  def change
    add_column :audio_files, :error, :string
  end
end
