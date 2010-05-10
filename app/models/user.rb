class User < ActiveRecord::Base
  acts_as_authentic
  
  validates_uniqueness_of :login, :email
  belongs_to :college
  
  def college_name
    college.abbr
  end
end
