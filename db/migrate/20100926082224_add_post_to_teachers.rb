class AddPostToTeachers < ActiveRecord::Migration
  def self.up
    add_column :teachers, :post, :string
  end

  def self.down
    remove_column :teachers, :post
  end
end
