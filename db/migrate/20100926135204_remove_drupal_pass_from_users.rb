class RemoveDrupalPassFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :drupal_pass
  end

  def self.down
    add_column :users, :drupal_pass, :string
  end
end
