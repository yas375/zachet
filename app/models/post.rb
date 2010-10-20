class Post < ActiveRecord::Base
  attr_accessible :text, :topic, :author

  belongs_to :topic
  belongs_to :author, :class_name => 'User'
  has_one :forum, :through => :topic

  validates_presence_of :topic, :text, :author
end
