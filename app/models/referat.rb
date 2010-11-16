class Referat < ActiveRecord::Base
  acts_as_zachet_content

  validates_presence_of :theme

  before_validation :cache_title

  def cache_title
    self.title = 'TODO'
  end
end
