class RemoveViewsFromTopic < ActiveRecord::Migration
  def self.up
    remove_column :topics, :views
  end

  def self.down
    add_column :topics, :views, :integer, :default => 0
  end
end
