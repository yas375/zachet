class AddCommentedToNewsitems < ActiveRecord::Migration
  def self.up
    add_column :newsitems, :commented, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :newsitems, :commented
  end
end
