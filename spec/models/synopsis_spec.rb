# -*- coding: utf-8 -*-
require 'spec_helper'

describe Synopsis do
  it "should create a new instance given valid attributes" do
    Synopsis.create!(:name => "Лала",
                     :teacher => "Петров Л.И.",
                     :semester => "semester_1",
                     :year => "2009",
                     :description => "value for description")
  end

  it "should have correct titles" do
    a = Synopsis.create!(:name => "Лала", :teacher => "Петров Л.И.", :semester => "semester_1", :year => "2010")
    a.title.should eql('Лала, 1ый семестр. Петров Л.И. 2010')

    b = Synopsis.create!(:name => "Лала", :teacher => "Петров Л.И.", :semester => "semester_2")
    b.title.should eql('Лала, 2ой семестр. Петров Л.И.')

    c = Synopsis.create!(:name => "Лала.", :teacher => "Петров Л.И.", :semester => "semester_3", :year => "2010")
    c.title.should eql('Лала, 3ий семестр. Петров Л.И. 2010')

    d = Synopsis.create!(:name => "Лала", :semester => "semester_4", :year => "2010")
    d.title.should eql('Лала, 4ый семестр. 2010')

    e = Synopsis.create!(:name => "Лала.", :semester => "semester_5", :year => "2010")
    e.title.should eql('Лала, 5ый семестр. 2010')

    f = Synopsis.create!(:name => "Лала", :teacher => "Петров Л.И.", :semester => "semester_6", :year => "2010")
    f.title.should eql('Лала, 6ой семестр. Петров Л.И. 2010')

    g = Synopsis.create!(:name => "Лала", :teacher => "Петров Л.И.", :year => "2010")
    g.title.should eql('Лала. Петров Л.И. 2010')

    h = Synopsis.create!(:name => "Лала.")
    h.title.should eql('Лала')

    i = Synopsis.create!(:teacher => "  Петров Л.И.", :year => "2010  ")
    i.title.should eql('Петров Л.И. 2010')

    i = Synopsis.create!(:teacher => " ", :year => "2010  ")
    i.title.should eql('2010')
  end
end
