class AddPostsCountToTopics < ActiveRecord::Migration
  def self.up
    add_column :topics, :posts_count, :integer, :default => 0
  end

  def self.down
    remove_column :topics, :posts_count
  end
end
