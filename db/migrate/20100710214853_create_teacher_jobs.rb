class CreateTeacherJobs < ActiveRecord::Migration
  def self.up
    create_table :teacher_jobs do |t|
      t.references :teacher, :null => false
      t.references :college, :null => false
      t.references :department

      t.timestamps
    end
  end

  def self.down
    drop_table :teacher_jobs
  end
end
