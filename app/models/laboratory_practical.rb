class LaboratoryPractical < ActiveRecord::Base
  acts_as_zachet_content

  validates_presence_of :name

  normalize_attributes :name, :with => [:strip, :without_dot]
  normalize_attributes :authors, :year, :publishing_company

  before_validation :cache_title

  def cache_title
    self.title = ''.tap do |t|
      t << name
      if publishing_company or year or authors
        t << '.'
        if authors
          t << " #{authors}"
          t << ',' if publishing_company or year
        end
        if publishing_company or year
          t << " #{publishing_company}" if publishing_company
          t << " #{year}" if year
        end
      end
    end
  end
end
