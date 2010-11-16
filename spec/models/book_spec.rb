# -*- coding: utf-8 -*-
require 'spec_helper'

describe Book do
  it "should create a new instance given valid attributes" do
    Book.create!(:name => "Лала",
                 :authors => "Петров Л.И.",
                 :publishing_company => "БГУИР",
                 :year => "2009",
                 :contents => "value for contents",
                 :description => "value for description"
                 )
  end

  it "should have correct titles" do
    a = Book.create!(:name => "Лала", :authors => "Петров Л.И.", :publishing_company => "БГУИР", :year => "2009")
    a.title.should eql('Лала. Петров Л.И., БГУИР 2010')

    b = Book.create!(:name => "Лала.", :authors => "Петров Л.И.", :publishing_company => "БГУИР")
    b.title.should eql('Лала. Петров Л.И., БГУИР')

    c = Book.create!(:name => "Лала", :publishing_company => "БГУИР", :year => "2009")
    c.title.should eql('Лала. БГУИР 2010')
  end
end
