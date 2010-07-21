class TeacherJob < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :college
  belongs_to :department

  has_many :teacher_subjects, :dependent => :destroy
  has_many :disciplines, :through => :teacher_subjects

  validates_presence_of :college
  validates_uniqueness_of :college_id, :scope => :teacher_id
end
