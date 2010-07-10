class RemoveDegreeFromTeacher < ActiveRecord::Migration
  def self.up
    remove_column :teachers, :degree
  end

  def self.down
    change_table :teachers do |t|
      t.string :degree
    end
  end
end
