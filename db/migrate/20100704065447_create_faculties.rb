class CreateFaculties < ActiveRecord::Migration
  def self.up
    create_table :faculties do |t|
      t.string :name
      t.string :abbr
      t.references :college

      t.timestamps
    end
  end

  def self.down
    drop_table :faculties
  end
end
