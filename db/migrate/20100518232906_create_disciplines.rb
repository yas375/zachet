class CreateDisciplines < ActiveRecord::Migration
  def self.up
    create_table :disciplines do |t|
      t.string :name
      t.string :abbr
      t.references :college
      t.timestamps
    end
  end
  
  def self.down
    drop_table :disciplines
  end
end
