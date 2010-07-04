class Department < ActiveRecord::Base
  validates_presence_of :name, :faculty
  validates_uniqueness_of :name, :scope => :faculty_id, :case_sensitive => false

  belongs_to :faculty
  has_one :college, :through => :faculties
end
