class CreateSynopses < ActiveRecord::Migration
  def self.up
    create_table :synopses do |t|
      t.string :title
      t.string :name
      t.string :teacher
      t.string :semester
      t.string :year
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :synopses
  end
end
