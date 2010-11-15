class CreateTests < ActiveRecord::Migration
  def self.up
    create_table :tests do |t|
      t.string :title
      t.string :theme
      t.string :number
      t.string :variant
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :tests
  end
end
