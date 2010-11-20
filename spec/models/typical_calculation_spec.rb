# -*- coding: utf-8 -*-
require 'spec_helper'

describe TypicalCalculation do

  it "should create a new instance given valid attributes" do
    TypicalCalculation.create!(:theme => "Лала",
                               :number => "2",
                               :variant => "1",
                               :description => "value for description")
  end

  it "should have correct titles" do
    a = TypicalCalculation.create!(:theme => "Лала", :number => "2", :variant => "1")
    a.title.should eql('ТР №2. Лала. Вариант 1')

    a = TypicalCalculation.create!(:theme => "Лала.", :number => "2", :variant => "1")
    a.title.should eql('ТР №2. Лала. Вариант 1')

    a = TypicalCalculation.create!(:theme => "Лала", :variant => "1")
    a.title.should eql('Лала. Вариант 1')

    a = TypicalCalculation.create!(:theme => "Лала", :number => "2")
    a.title.should eql('ТР №2. Лала')

    a = TypicalCalculation.create!(:theme => "Лала.", :number => "2")
    a.title.should eql('ТР №2. Лала')

    a = TypicalCalculation.create!(:number => "2", :variant => "1")
    a.title.should eql('ТР №2. Вариант 1')
  end
end
