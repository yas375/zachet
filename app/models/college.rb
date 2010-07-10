class College < ActiveRecord::Base
  validates_presence_of :abbr, :name, :subdomain
  validates_uniqueness_of :abbr, :name, :subdomain, :case_sensitive => false
  validates_format_of :subdomain, :with => /\A[a-z]+\z/, :message => 'допускаются только маленькие буквы латинского алфавита'

  has_many :users, :dependent => :nullify
  has_many :news_colleges, :dependent => :destroy
  has_many :newsitems, :through => :news_colleges
  has_many :disciplines, :dependent => :destroy
  has_many :faculties, :dependent => :destroy
  has_many :departments, :through => :faculties
  has_many :teacher_jobs, :dependent => :destroy
  has_many :teachers, :through => :teacher_jobs
end
