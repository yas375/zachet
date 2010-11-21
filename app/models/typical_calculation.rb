# -*- coding: utf-8 -*-
class TypicalCalculation < ActiveRecord::Base
  acts_as_zachet_content

  normalize_attributes :theme, :with => [:strip, :without_dot, :blank]
  normalize_attributes :number, :variant

  before_validation :cache_title

  def cache_title
    self.title = ''.tap do |t|
      t << "ТР №#{number}" if number
      if theme or variant
        t << ". " if number
        if theme
          t << theme
          t << '. ' if variant
        end
        t << "Вариант #{variant}" if variant
      end
    end
  end
end
