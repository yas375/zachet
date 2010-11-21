class Synopsis < ActiveRecord::Base
  acts_as_zachet_content

  normalize_attributes :name, :with => [:strip, :without_dot, :blank]
  normalize_attributes :teacher, :year

  symbolize :semester, :in => ActiveRecord::ZachetContent::SEMESTRES, :allow_nil => true

  before_validation :cache_title

  def cache_title
    self.title = ''.tap do |t|
      t << name if name
      if semester
        t << ", " if t.present?
        t << I18n.t("semesters.#{semester}")
      end
      if teacher or year
        t << "." if t.present?
        if teacher
          t << " " if t.present?
          t << teacher
        end
        if year
          t << " " if t.present?
          t << year
        end
      end
    end
  end
end
