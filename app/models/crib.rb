class Crib < ActiveRecord::Base
  acts_as_zachet_content
  belongs_to :teacher, :class_name => 'User'
end
