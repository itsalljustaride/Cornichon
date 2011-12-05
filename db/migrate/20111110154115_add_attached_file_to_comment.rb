class AddAttachedFileToComment < ActiveRecord::Migration
  def self.up
    add_column :comments, :audio_file_name,    :string
    add_column :comments, :audio_content_type, :string
    add_column :comments, :audio_file_size,    :integer
    add_column :comments, :audio_updated_at,   :datetime
    add_column :comments, :audio_length,       :float
  end

  def self.down
    remove_column :comments, :audio_file_name
    remove_column :comments, :audio_content_type
    remove_column :comments, :audio_file_size
    remove_column :comments, :audio_updated_at
    remove_column :comments, :audio_length
  end
end
