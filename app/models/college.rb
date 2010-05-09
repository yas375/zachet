class College < ActiveRecord::Base
  validates_presence_of :abbr, :name, :subdomain
  validates_uniqueness_of :abbr, :name, :subdomain, :case_sensitive => false
  has_many :users, :dependent => :nullify
end
