class Faculty < ActiveRecord::Base
  belongs_to :college
  validates_presence_of :name, :college
  validates_uniqueness_of :name, :scope => :college_id, :case_sensitive => false
end
