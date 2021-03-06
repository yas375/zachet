class Material < ActiveRecord::Base
  acts_as_visitable
  acts_as_commentable

  belongs_to :created_by, :class_name => 'User'
  belongs_to :discipline
  belongs_to :data, :polymorphic => true, :dependent => :destroy

  has_one :college, :through => :discipline

  has_many :attaches, :dependent => :destroy, :as => :container
  accepts_nested_attributes_for :attaches

  validates_presence_of :discipline, :created_by

  scope :find_by_college, lambda { |college|
    joins('LEFT JOIN disciplines d on discipline_id = d.id').where('d.college_id=?', college.id)
  }

  def title
    attr = read_attribute :title
    if attr.present?
      attr
    elsif data
      self.update_attribute(:title, data.title)
      title
    else
      nil
    end
  end
end
