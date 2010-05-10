class CreateNewsColleges < ActiveRecord::Migration
  def self.up
    create_table :news_colleges do |t|
      t.references :college
      t.references :newsitem
    end
  end

  def self.down
    drop_table :news_colleges
  end
end
