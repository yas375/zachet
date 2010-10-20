class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.integer :forum_id
      t.string :subject
      t.integer :author_id
      t.integer :last_post_id
      t.boolean :locked, :default => false
      t.integer :views, :default => 0
      t.boolean :sticky, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :topics
  end
end
