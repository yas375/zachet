class CreateTeacherPhotos < ActiveRecord::Migration
  def self.up
    create_table :teacher_photos do |t|
      t.references :teacher
      t.string :picture_file_name
      t.string :picture_content_type
      t.integer :picture_file_size
      t.datetime :picture_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :teacher_photos
  end
end
