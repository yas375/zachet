class Faculty < ActiveRecord::Base
  belongs_to :college
  has_many :departments, :dependent => :destroy
  validates_presence_of :name, :college
  validates_uniqueness_of :name, :scope => :college_id, :case_sensitive => false

  scope :by_college, lambda { |college_id| {:conditions => {:college_id => college_id}} }
end
