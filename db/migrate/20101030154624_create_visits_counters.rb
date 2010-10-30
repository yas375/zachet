class CreateVisitsCounters < ActiveRecord::Migration
  def self.up
    create_table :visits_counters do |t|
      t.integer :visitable_id
      t.string :visitable_type
      t.integer :count, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :visits_counters
  end
end
