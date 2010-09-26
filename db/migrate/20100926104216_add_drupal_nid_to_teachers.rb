class AddDrupalNidToTeachers < ActiveRecord::Migration
  def self.up
    add_column :teachers, :drupal_nid, :integer
  end

  def self.down
    remove_column :teachers, :drupal_nid
  end
end
