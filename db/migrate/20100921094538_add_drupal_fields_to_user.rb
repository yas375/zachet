class AddDrupalFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :drupal_uid, :integer
    add_column :users, :drupal_pass, :string
  end

  def self.down
    remove_column :users, :drupal_pass
    remove_column :users, :drupal_uid
  end
end
