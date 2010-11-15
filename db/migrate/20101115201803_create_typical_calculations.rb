class CreateTypicalCalculations < ActiveRecord::Migration
  def self.up
    create_table :typical_calculations do |t|
      t.string :title
      t.string :theme
      t.string :number
      t.string :variant
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :typical_calculations
  end
end
