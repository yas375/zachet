class AddNidToDepartments < ActiveRecord::Migration
  def self.up
    add_column :departments, :drupal_nid, :integer
  end

  def self.down
    remove_column :departments, :drupal_nid
  end
end
