class AddTidToDisciplines < ActiveRecord::Migration
  def self.up
    add_column :disciplines, :drupal_tid, :integer
  end

  def self.down
    remove_column :disciplines, :drupal_tid
  end
end
