# -*- coding: utf-8 -*-
require 'spec_helper'

describe Crib do
  it "should create a new instance given valid attributes" do
    Crib.create!(:name => "Лала",
                 :teacher => "",
                 :semester => "semester_1",
                 :number_of_questions => 25,
                 :number_of_questions_with_answers => 23,
                 :questions => 'questions list goes here',
                 :description => "value for description"
                 )
  end

  it "should have correct titles" do
    a = Crib.create!(:name => "Лала",
                     :teacher => "Борбот Л.И. ",
                     :semester => "semester_1",
                     :number_of_questions => 25,
                     :number_of_questions_with_answers => 23)
    a.title.should eql('Лала, 1ый семестр. (Борбот Л.И.) [23/25 вопросов]')

    b = Crib.create!(:name => "Лала",
                     :teacher => "Борбот Л.И.",
                     :semester => "semester_2",
                     :number_of_questions_with_answers => 23)
    b.title.should eql('Лала, 2ой семестр. (Борбот Л.И.)')

    c = Crib.create!(:name => "Лала",
                     :teacher => "Борбот Л.И.",
                     :semester => "semester_3",
                     :number_of_questions => 25)
    c.title.should eql('Лала, 3ий семестр. (Борбот Л.И.)')

    d = Crib.create!(:name => "Лала",
                     :semester => "semester_4",
                     :number_of_questions => 25,
                     :number_of_questions_with_answers => 23)
    d.title.should eql('Лала, 4ый семестр. [23/25 вопросов]')

    d = Crib.create!(:name => "",
                     :semester => "",
                     :number_of_questions => 25,
                     :number_of_questions_with_answers => 23)
    d.title.should eql('23/25 вопросов')

    e = Crib.create!(:teacher => "Борбот Л.И.",
                     :semester => "semester_5",
                     :number_of_questions_with_answers => 23)
    e.title.should eql('5ый семестр. (Борбот Л.И.)')

    e = Crib.create!(:teacher => "Борбот Л.И.",
                     :semester => "",
                     :number_of_questions_with_answers => 23)
    e.title.should eql('Борбот Л.И.')

    f = Crib.create!(:name => "Лала.",
                     :semester => "semester_6",
                     :number_of_questions_with_answers => 23)
    f.title.should eql('Лала, 6ой семестр')

    g = Crib.create!(:name => "Лала.",
                     :number_of_questions_with_answers => 23)
    g.title.should eql('Лала')
  end
end
