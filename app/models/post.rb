class Post < ActiveRecord::Base
  attr_accessible :text, :topic, :author

  belongs_to :topic
  belongs_to :author, :class_name => 'User'
  has_one :forum, :through => :topic

  validates_presence_of :text, :author

  after_create :increment_counters_and_set_last_post
  before_destroy :decrement_counters_and_set_last_post_to_previous

  def previous_post
    topic.posts.last(:order => 'created_at', :conditions => ['id <> ?', id])
  end

  private
  def increment_counters_and_set_last_post
    topic.increment!(:posts_count)
    topic.update_attribute :last_post, self

#    topic.forum.self_and_ancestors.each do |f|
#      f.update_attribute :last_post, self
#      f.increment! :posts_count
#    end
  end

  def decrement_counters_and_set_last_post_to_previous
    topic.decrement!(:posts_count)
    topic.update_last_post!(self)

#    topic.forum.self_and_ancestors.each do |f|
#      f.update_last_post!(self)
#      f.decrement! :posts_count
#    end
  end
end
