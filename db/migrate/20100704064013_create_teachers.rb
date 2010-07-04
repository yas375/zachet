class CreateTeachers < ActiveRecord::Migration
  def self.up
    create_table :teachers do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :degree
      t.string :email
      t.text :text

      t.timestamps
    end
  end

  def self.down
    drop_table :teachers
  end
end
