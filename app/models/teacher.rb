class Teacher < ActiveRecord::Base
  validates_presence_of :last_name

  has_many :teacher_jobs, :dependent => :destroy
  accepts_nested_attributes_for :teacher_jobs, :reject_if => proc { |j| j[:college_id].blank? }, :allow_destroy => true
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
