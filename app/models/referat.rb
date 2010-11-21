class Referat < ActiveRecord::Base
  acts_as_zachet_content

  validates_presence_of :theme

  normalize_attributes :theme, :with => [:strip, :without_dot]
  normalize_attributes :year, :author

  before_validation :cache_title

  def cache_title
    self.title = ''.tap do |t|
      t << theme
      if year or author
        t << '.'
        if author
          t << " #{author}"
          t << ',' if year
        end
        t << " #{year}" if year
      end
    end
  end
end
