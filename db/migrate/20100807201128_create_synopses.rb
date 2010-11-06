class CreateSynopses < ActiveRecord::Migration
  def self.up
    create_table :synopses do |t|
      t.string :title
      t.text :body
      t.string :year
      t.references :author
      t.references :discipline
      t.references :teacher
      t.boolean :commented, :null => false, :default => false
      t.boolean :published, :null => false, :default => false
      t.boolean :promoted, :null => false, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :synopses
  end
end
