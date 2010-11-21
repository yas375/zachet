# -*- coding: utf-8 -*-
require 'spec_helper'

describe Lab do
  it "should create a new instance given valid attributes" do
    Lab.create!(:theme => "Лала",
                :number => "2",
                :variant => "3",
                :description => "value for description")
  end

  it "should have correct titles" do
    a = Lab.create!(:theme => "Лала", :number => "2", :variant => "3")
    a.title.should eql('Лаба №2. Лала. Вариант 3')

    a = Lab.create!(:theme => "Лала", :number => "2", :variant => "3,4")
    a.title.should eql('Лаба №2. Лала. Вариант 3,4')

    a = Lab.create!(:theme => "Лала   ", :number => "2", :variant => "3-5")
    a.title.should eql('Лаба №2. Лала. Вариант 3-5')

    a = Lab.create!(:theme => "Лала", :number => "2-3", :variant => "3")
    a.title.should eql('Лаба №2-3. Лала. Вариант 3')

    a = Lab.create!(:theme => "Лала", :number => "2")
    a.title.should eql('Лаба №2. Лала')

    a = Lab.create!(:theme => "Лала.", :number => "2")
    a.title.should eql('Лаба №2. Лала')

    a = Lab.create!(:theme => "Лала.", :variant => "3")
    a.title.should eql('Лала. Вариант 3')

    a = Lab.create!(:theme => "Лала")
    a.title.should eql('Лала')

    a = Lab.create!(:variant => "3")
    a.title.should eql('Вариант 3')

    a = Lab.create!(:number => "2-3", :variant => "3")
    a.title.should eql('Лаба №2-3. Вариант 3')

    a = Lab.create!(:number => "2-3")
    a.title.should eql('Лаба №2-3')
  end
end
