class AddTeaserToNewsitems < ActiveRecord::Migration
  def self.up
    add_column :newsitems, :teaser, :text
  end

  def self.down
    remove_column :newsitems, :teaser
  end
end
