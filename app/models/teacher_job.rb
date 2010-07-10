class TeacherJob < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :college
  belongs_to :department

  validates_presence_of :teacher, :college
end
