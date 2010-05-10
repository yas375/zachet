class Newsitem < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :title, :body
  
  def author
    user.login
  end
  
  def colleges
    'asasd'
  end
end
