class CreateContentManuals < ActiveRecord::Migration
  def self.up
    create_table :content_manuals do |t|
      t.string :title
      t.text :body
      t.string :type
      t.references :author
      t.references :discipline
      t.boolean :commented, :null => false, :default => false
      t.boolean :published, :null => false, :default => false
      t.boolean :promoted, :null => false, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :content_manuals
  end
end
