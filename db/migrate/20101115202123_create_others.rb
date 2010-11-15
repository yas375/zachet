class CreateOthers < ActiveRecord::Migration
  def self.up
    create_table :others do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :others
  end
end
