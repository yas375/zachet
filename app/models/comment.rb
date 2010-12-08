class Comment < ActiveRecord::Base
  attr_accessible :text, :parent_id, :author, :commentable

  belongs_to :commentable, :polymorphic => true
  acts_as_nested_set :scope => [:commentable_id, :commentable_type]

  belongs_to :author, :class_name => 'User'

  validates_presence_of :text, :author, :commentable
end
