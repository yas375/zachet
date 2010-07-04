class Department < ActiveRecord::Base
  belongs_to :faculty
  validates_presence_of :name, :faculty
  validates_uniqueness_of :name, :scope => :faculty_id, :case_sensitive => false
end
