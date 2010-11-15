class Material < ActiveRecord::Base
  belongs_to :author, :class_name => 'User'
  belongs_to :discipline
  belongs_to :data, :polymorphic => true

  has_one :college, :through => :discipline

  validates_presence_of :title, :discipline, :author

  named_scope :find_by_college, lambda { |college|
    { :joins => ['LEFT JOIN disciplines d on discipline_id = d.id'],
      :conditions => ['d.college_id=?', college.id] }
  }
end
