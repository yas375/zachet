class Newsitem < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :title, :body

  has_many :news_colleges, :dependent => :destroy
  has_many :colleges, :through => :news_colleges
  
  def author
    user.login
  end
  
  # def colleges
  #   'asasd'
  # end
end
