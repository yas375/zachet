class Synopsis < ActiveRecord::Base
  acts_as_zachet_content

  before_validation :cache_title

  def cache_title
    self.title = 'TODO'
  end
end
