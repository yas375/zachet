class CreateVisitsLogs < ActiveRecord::Migration
  def self.up
    create_table :visits_logs do |t|
      t.integer :loggable_id
      t.string :loggable_type
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :visits_logs
  end
end
