class Discipline < ActiveRecord::Base
  belongs_to :college

  has_many :teacher_subjects, :dependent => :destroy
  has_many :materials, :dependent => :nullify
  # TODO move to acts_as_zachet_content
  has_many :cribs, :class_name => 'Material', :conditions => ['materials.data_type=?', :crib]

  validates_presence_of :name, :college
  validates_uniqueness_of :name, :scope => :college_id, :case_sensitive => false

  def display_name
    res = read_attribute('name')
    res << " (#{abbr})" if abbr
    res
  end
end
