class College < ActiveRecord::Base
  has_friendly_id :subdomain, :use_slug => false

  validates_presence_of :abbr, :name, :subdomain
  validates_uniqueness_of :abbr, :name, :subdomain, :case_sensitive => false
  has_many :users, :dependent => :nullify

  has_many :news_colleges, :dependent => :destroy
  has_many :newsitems, :through => :news_colleges
  has_many :disciplines, :dependent => :destroy
end
