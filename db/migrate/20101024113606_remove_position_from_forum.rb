class RemovePositionFromForum < ActiveRecord::Migration
  def self.up
    remove_column :forums, :position
  end

  def self.down
    add_column :forums, :position, :integer
  end
end
