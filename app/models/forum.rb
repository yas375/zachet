class Forum < ActiveRecord::Base
  attr_accessible :title, :description, :parent_id

  acts_as_nested_set

  has_many :topics, :dependent => :destroy
  has_many :posts, :through => :topics

  validates_presence_of :title, :parent_id

  # TODO counters of posts and topics
end
