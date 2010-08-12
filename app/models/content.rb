class Content < ActiveRecord::Base
  belongs_to :author, :class_name => 'User'
  belongs_to :discipline
  has_one :college, :through => :discipline

  validates_presence_of :title, :body, :discipline, :author

  named_scope :find_by_college, lambda { |college|
    { :joins => ['LEFT JOIN disciplines d on discipline_id = d.id'],
      :conditions => ['d.college_id=?', college.id] }
  }
end