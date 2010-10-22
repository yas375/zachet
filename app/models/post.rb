class Post < ActiveRecord::Base
  attr_accessible :text, :topic, :author

  belongs_to :topic
  belongs_to :author, :class_name => 'User'
  has_one :forum, :through => :topic

  validates_presence_of :text, :author

  after_save :update_topic

  def update_topic
    topic.update_attribute(:last_post_id, id)
  end
end
