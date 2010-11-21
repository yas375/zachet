# -*- coding: utf-8 -*-
require 'spec_helper'

describe Referat do
  it "should create a new instance given valid attributes" do
    Referat.create!(:theme => "Лала",
                    :author => "Иванов",
                    :year => "2010",
                    :description => "value for description"
                    )
  end

  it "should have correct title" do
    a = Referat.create!(:theme => "Лала", :author => "Иванов", :year => "2010")
    a.title.should eql('Лала. Иванов, 2010')

    b = Referat.create!(:theme => "Лала.", :author => " Иванов", :year => "2010")
    b.title.should eql('Лала. Иванов, 2010')

    c = Referat.create!(:theme => "Лала  ", :year => "2010 ")
    c.title.should eql('Лала. 2010')

    d = Referat.create!(:theme => "Лала.", :year => "")
    d.title.should eql('Лала')
  end
end
