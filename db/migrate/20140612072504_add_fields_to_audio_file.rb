class AddFieldsToAudioFile < ActiveRecord::Migration
  def change
    add_column :audio_files, :url, :string
    add_column :audio_files, :processing, :boolean, default: false
    add_column :audio_files, :slug, :string
    add_column :audio_files, :info, :text
  end
end
