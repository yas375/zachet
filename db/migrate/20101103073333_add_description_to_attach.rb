class AddDescriptionToAttach < ActiveRecord::Migration
  def self.up
    add_column :attaches, :description, :string, :default => ''
  end

  def self.down
    remove_column :attaches, :description
  end
end
