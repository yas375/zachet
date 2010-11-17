# -*- coding: utf-8 -*-
require 'spec_helper'

describe Synopsis do
  it "should create a new instance given valid attributes" do
    Synopsis.create!(:name => "Лала",
                     :teacher => "Петров Л.И.",
                     :semester => "1st_semester",
                     :year => "2009",
                     :description => "value for description")
  end

  it "should have correct titles" do
    a = Synopsis.create!(:name => "Лала", :teacher => "Петров Л.И.", :semester => "1st_semester", :year => "2010")
    a.title.should eql('Лала, Петров Л.И. 2010, 1ый семестр')

    b = Synopsis.create!(:name => "Лала", :teacher => "Петров Л.И.", :semester => "2nd_semester")
    b.title.should eql('Лала, Петров Л.И., 2ой семестр')

    c = Synopsis.create!(:name => "Лала.", :teacher => "Петров Л.И.", :semester => "3rd_semester", :year => "2010")
    c.title.should eql('Лала, Петров Л.И. 2010, 3ий семестр')

    d = Synopsis.create!(:name => "Лала", :semester => "4th_semester", :year => "2010")
    d.title.should eql('Лала. 2010, 4ый семестр')

    e = Synopsis.create!(:name => "Лала.", :semester => "5th_semester", :year => "2010")
    e.title.should eql('Лала. 2010, 5ый семестр')

    f = Synopsis.create!(:name => "Лала", :teacher => "Петров Л.И.", :semester => "6th_semester", :year => "2010")
    f.title.should eql('Лала, Петров Л.И. 2010, 6ой семестр')

    g = Synopsis.create!(:name => "Лала", :teacher => "Петров Л.И.", :year => "2010")
    g.title.should eql('Лала, Петров Л.И. 2010')

    h = Synopsis.create!(:name => "Лала.")
    h.title.should eql('Лала')

    i = Synopsis.create!(:teacher => "Петров Л.И.", :year => "2010")
    i.title.should eql('Петров Л.И. 2010')
  end
end
