class Discipline < ActiveRecord::Base
  belongs_to :college
  validates_presence_of :name, :college
end
