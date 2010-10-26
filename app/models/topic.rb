# -*- coding: utf-8 -*-
class Topic < ActiveRecord::Base
  attr_accessible :forum, :subject, :author, :locked, :sticky

  belongs_to :forum
  belongs_to :author, :class_name => 'User'

  validates_presence_of :forum, :subject, :author
  validate :forum_cannot_be_in_top_levels

  has_many :posts, :dependent => :destroy
  belongs_to :last_post, :class_name => 'Post'

  after_create :increment_counters_and_set_last_post
  before_destroy :decrement_counters_and_update_last_post

  def forum_cannot_be_in_top_levels
    errors.add_to_base("Нельзя создавать темы в форумах верхнего уровня.") if forum.level <= 1
  end

  def update_last_post!(without = nil)
    update_attribute :last_post, posts.last(:order => 'created_at', :conditions => ['id <> ?', without.try(:id)])
  end

  private
  def increment_counters_and_set_last_post
    forum.self_and_ancestors.each do |f|
      f.increment!(:topics_count)
    end
  end

  def decrement_counters_and_update_last_post
    forum.self_and_ancestors.each do |f|
      f.decrement!(:topics_count)
    end
  end
end
