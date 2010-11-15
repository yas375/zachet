class CreateTermPapers < ActiveRecord::Migration
  def self.up
    create_table :term_papers do |t|
      t.string :title
      t.string :theme
      t.string :author
      t.string :year
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :term_papers
  end
end
