class Newsitem < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :title, :body, :user

  has_many :news_colleges, :dependent => :destroy
  has_many :colleges, :through => :news_colleges

  # глобальные новоти сайта.
  named_scope :global, :joins => 'LEFT JOIN news_colleges nc ON nc.newsitem_id=newsitems.id',
                       :conditions => 'nc.id IS NULL',
                       :group => 'newsitems.id'

  # новости всех универов, но не глобальные новоти сайта.
  named_scope :local_all, :joins => 'INNER JOIN news_colleges nc ON nc.newsitem_id=newsitems.id',
                          :group => 'newsitems.id'

  def author
    user.login
  end
end
