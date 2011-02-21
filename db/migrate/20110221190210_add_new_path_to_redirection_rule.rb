class AddNewPathToRedirectionRule < ActiveRecord::Migration
  def self.up
    add_column :redirection_rules, :new_path, :string
  end

  def self.down
    remove_column :redirection_rules, :new_path
  end
end
