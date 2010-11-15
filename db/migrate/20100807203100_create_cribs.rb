class CreateCribs < ActiveRecord::Migration
  def self.up
    create_table :cribs do |t|
      t.string :title
      t.string :name
      t.string :teacher
      t.string :semester
      t.integer :number_of_questions
      t.integer :number_of_questions_with_answers
      t.text :questions
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :cribs
  end
end
