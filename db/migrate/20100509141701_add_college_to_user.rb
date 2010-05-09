class AddCollegeToUser < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.references :college
    end
  end

  def self.down
    remove_column :users, :college
  end
end
