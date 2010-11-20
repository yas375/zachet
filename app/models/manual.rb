class Manual < ActiveRecord::Base
  acts_as_zachet_content

  validates_presence_of :name

  before_validation :cache_title

  def cache_title
    self.title = 'TODO'
  end
end
