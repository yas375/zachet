# -*- coding: utf-8 -*-
class Crib < ActiveRecord::Base
  acts_as_zachet_content

  normalize_attributes :name, :with => [:strip, :without_dot, :blank]
  normalize_attributes :teacher
  validates_numericality_of :number_of_questions, :number_of_questions_with_answers, :allow_nil => true, :only_integer => true

  symbolize :semester, :in => ActiveRecord::ZachetContent::SEMESTRES, :allow_nil => true

  before_validation :cache_title

  def cache_title
    self.title = ''.tap do |t|
      t << name if name
      if semester
        t << ", " if t.present?
        t << I18n.t("semesters.#{semester}")
      end
      t << "." if t.present? and (teacher or (number_of_questions and number_of_questions_with_answers))
      if teacher
        if t.present?
          t << " (#{teacher})"
        else
          t << "#{teacher}"
        end
      end
      if number_of_questions and number_of_questions_with_answers
        if t.empty?
          t << "#{number_of_questions_with_answers}/#{number_of_questions} вопросов"
        else
          t << " [#{number_of_questions_with_answers}/#{number_of_questions} вопросов]"
        end
      end
    end
  end
end
