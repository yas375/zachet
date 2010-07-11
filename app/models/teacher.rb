class Teacher < ActiveRecord::Base
  validates_presence_of :last_name

  has_many :teacher_jobs, :dependent => :destroy
  has_many :teacher_subjects, :through => :teacher_jobs

  def name
    res = last_name
    unless first_name.blank?
      res << " #{first_name}"
      res << " #{middle_name}" unless middle_name.blank?
    end
    res
  end

  def colleges
    teacher_jobs.collect { |a| a.college }
  end
end
