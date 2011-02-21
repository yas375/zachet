class AddIpToVisitsLog < ActiveRecord::Migration
  def self.up
    add_column :visits_logs, :ip, :string
  end

  def self.down
    remove_column :visits_logs, :ip
  end
end
