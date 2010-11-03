class CreateAttaches < ActiveRecord::Migration
  def self.up
    create_table :attaches do |t|
      t.integer :container_id,   :null => false
      t.string  :container_type, :null => false
      t.string :file_file_name
      t.string :file_content_type
      t.integer :file_file_size
      t.datetime :file_updated_at
    end
  end

  def self.down
    drop_table :attaches
  end
end
