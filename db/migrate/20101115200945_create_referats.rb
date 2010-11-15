class CreateReferats < ActiveRecord::Migration
  def self.up
    create_table :referats do |t|
      t.string :title
      t.string :theme
      t.string :author
      t.string :year
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :referats
  end
end
