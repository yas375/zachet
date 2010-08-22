class Discipline < ActiveRecord::Base
  belongs_to :college

  has_many :teacher_subjects, :dependent => :destroy
  has_many :content_manuals, :class_name => 'Content::Manual'
  has_many :content_cribs, :class_name => 'Content::Crib'
  has_many :content_synopses, :class_name => 'Content::Synopsis'

  validates_presence_of :name, :college
  validates_uniqueness_of :name, :scope => :college_id, :case_sensitive => false

  def name
    res = read_attribute('name')
    res << " (#{abbr})" if abbr
    res
  end
end
