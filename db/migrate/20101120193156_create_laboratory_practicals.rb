class CreateLaboratoryPracticals < ActiveRecord::Migration
  def self.up
    create_table :laboratory_practicals do |t|
      t.string :title
      t.string :name
      t.string :authors
      t.string :publishing_company
      t.string :year
      t.text :content
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :laboratory_practicals
  end
end
