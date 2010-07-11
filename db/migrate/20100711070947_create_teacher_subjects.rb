class CreateTeacherSubjects < ActiveRecord::Migration
  def self.up
    create_table :teacher_subjects do |t|
      t.references :discipline
      t.references :teacher_job

      t.timestamps
    end
  end

  def self.down
    drop_table :teacher_subjects
  end
end
