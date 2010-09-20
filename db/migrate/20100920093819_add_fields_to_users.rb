class AddFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :gender, :string
    add_column :users, :birthday, :date
    add_column :users, :city, :string
    add_column :users, :twitter, :string
    add_column :users, :jabber, :string
    add_column :users, :skype, :string
    add_column :users, :icq, :string
    add_column :users, :description, :text
    add_column :users, :faculty, :string
    add_column :users, :speciality, :string
    add_column :users, :loved_discipline, :string
    add_column :users, :unloved_discipline, :string
  end

  def self.down
    remove_column :users, :unloved_discipline
    remove_column :users, :loved_discipline
    remove_column :users, :speciality
    remove_column :users, :faculty_id
    remove_column :users, :description
    remove_column :users, :icq
    remove_column :users, :skype
    remove_column :users, :jabber
    remove_column :users, :twitter
    remove_column :users, :city
    remove_column :users, :birthday
    remove_column :users, :gender
    remove_column :users, :last_name
    remove_column :users, :first_name
  end
end
