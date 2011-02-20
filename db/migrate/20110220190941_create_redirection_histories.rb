class CreateRedirectionHistories < ActiveRecord::Migration
  def self.up
    create_table :redirection_histories do |t|
      t.string :ip
      t.string :user_agent
      t.string :http_host
      t.string :request_uri
      t.integer :redirection_rule_id
      t.string :destination
      t.text :env

      t.timestamps
    end
  end

  def self.down
    drop_table :redirection_histories
  end
end
