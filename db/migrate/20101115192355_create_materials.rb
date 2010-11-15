class CreateMaterials < ActiveRecord::Migration
  def self.up
    create_table :materials do |t|
      t.string :title
      t.references :author
      t.references :discipline
      t.boolean :commented, :default => false
      t.boolean :published, :default => false
      t.boolean :promoted, :default => false
      t.integer :data_id
      t.string :data_type

      t.timestamps
    end
  end

  def self.down
    drop_table :materials
  end
end
