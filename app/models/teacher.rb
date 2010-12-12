class Teacher < ActiveRecord::Base
  acts_as_visitable
  acts_as_commentable

  belongs_to :author, :class_name => 'User'

  validates_presence_of :last_name

  has_many :teacher_jobs, :dependent => :destroy
  accepts_nested_attributes_for :teacher_jobs, :reject_if => proc { |j| j[:college_id].blank? }, :allow_destroy => true
  has_many :teacher_subjects, :through => :teacher_jobs

  has_many :teacher_photos, :dependent => :destroy
  accepts_nested_attributes_for :teacher_photos, :allow_destroy => true

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
