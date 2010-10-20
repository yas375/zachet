class Topic < ActiveRecord::Base
  attr_accessible :forum, :subject, :author

  belongs_to :forum
  belongs_to :author, :class_name => 'User'

  validates_presence_of :forum, :subject, :author

  has_many :posts, :dependent => :destroy

  after_create :increment_counters
  before_destroy :decrement_counters

  private

  def increment_counters
    forum.increment!(:topics_count)
  end

  def decrement_counters
    forum.decrement!(:topics_count)
  end

  def increment_posts_count!
    forum.increment!(:posts_count)
  end

  def decrement_posts_count!
    forum.decrement!(:posts_count)
  end
end
