class Discipline < ActiveRecord::Base
  belongs_to :college

  has_many :teacher_subjects, :dependent => :destroy
  has_many :manuals
  has_many :cribs
  has_many :synopses

  validates_presence_of :name, :college
  validates_uniqueness_of :name, :scope => :college_id, :case_sensitive => false

  def display_name
    res = read_attribute('name')
    res << " (#{abbr})" if abbr
    res
  end
end
