class CreateForums < ActiveRecord::Migration
  def self.up
    create_table :forums do |t|
      t.string :title
      t.text :description
      t.integer :position
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :last_post_id
      t.integer :topics_count, :default => 0
      t.integer :posts_count, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :forums
  end
end
