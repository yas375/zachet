# -*- coding: utf-8 -*-
require 'spec_helper'

describe LaboratoryPractical do
  it "should create a new instance given valid attributes" do
    LaboratoryPractical.create!(:name => "Лала",
                                :authors => "Петров Л.И.",
                                :publishing_company => "БГУИР",
                                :year => "2009",
                                :content => "value for content",
                                :description => "value for description"
                                )
  end

  it "should have correct titles" do
    a = LaboratoryPractical.create!(:name => "Лала", :authors => "Петров Л.И.", :publishing_company => "БГУИР", :year => "2009")
    a.title.should eql('Лала. Петров Л.И., БГУИР 2010')

    b = LaboratoryPractical.create!(:name => "Лала.", :authors => "Петров Л.И.", :publishing_company => "БГУИР")
    b.title.should eql('Лала. Петров Л.И., БГУИР')

    c = LaboratoryPractical.create!(:name => "Лала", :publishing_company => "БГУИР", :year => "2009")
    c.title.should eql('Лала. БГУИР 2010')
  end
end
