class CreateRedirectionRules < ActiveRecord::Migration
  def self.up
    create_table :redirection_rules do |t|
      t.string :old_path
      t.string :subdomain
      t.integer :object_id
      t.string :object_type

      t.timestamps
    end
    add_index :redirection_rules, :old_path, :unique => true
  end

  def self.down
    remove_index :redirection_rules, :old_path
    drop_table :redirection_rules
  end
end
