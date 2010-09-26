class AddAuthorToTeachers < ActiveRecord::Migration
  def self.up
    add_column :teachers, :author_id, :integer
  end

  def self.down
    remove_column :teachers, :author_id
  end
end
