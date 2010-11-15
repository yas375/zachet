class CreateBooks < ActiveRecord::Migration
  def self.up
    create_table :books do |t|
      t.string :title
      t.string :name
      t.string :authors
      t.string :publishing_company
      t.string :year
      t.text :contents
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :books
  end
end
