class CreateCribs < ActiveRecord::Migration
  def self.up
    create_table :cribs do |t|
      t.string :title
      t.text :body
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
    drop_table :cribs
  end
end
