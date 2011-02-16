class Department < ActiveRecord::Base
  validates_presence_of :name, :faculty_id
  validates_uniqueness_of :name, :scope => :faculty_id, :case_sensitive => false

  belongs_to :faculty
  has_one :college, :through => :faculty

  named_scope :by_college, lambda { |college_id| {:joins => "LEFT JOIN faculties f ON departments.faculty_id = f.id",
                                                  :conditions => ["f.college_id = ?", college_id]} }

  def title
    t = name
    t << " #{abbr})" unless abbr.blank?
    t
  end
end
