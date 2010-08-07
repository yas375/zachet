class Content < ActiveRecord::Base
  belongs_to :author, :class_name => 'User'
  belongs_to :discipline

  validates_presence_of :title, :body, :discipline
end
