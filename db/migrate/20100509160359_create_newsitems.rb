class CreateNewsitems < ActiveRecord::Migration
  def self.up
    create_table :newsitems do |t|
      t.string :title
      t.text :body
      t.reference :college
      t.reference :user
      t.boolean :published

      t.timestamps
    end
  end

  def self.down
    drop_table :newsitems
  end
end
