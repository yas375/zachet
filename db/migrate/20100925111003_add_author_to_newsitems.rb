class AddAuthorToNewsitems < ActiveRecord::Migration
  def self.up
    add_column :newsitems, :author_id, :integer
  end

  def self.down
    remove_column :newsitems, :author_id
  end
end
