# -*- coding: utf-8 -*-
require 'spec_helper'

describe ControlWork do
  it "should create a new instance given valid attributes" do
    ControlWork.create!(:theme => "Итоговая за первое полугодие",
                        :number => "2",
                        :variant => "1",
                        :description => "value for description")
  end

  it "should have correct title" do
    a = ControlWork.create!(:theme => "Лала", :number => "2", :variant => "1")
    a.title.should eql('КР №2. Лала. Вариант 1')

    b = ControlWork.create!(:theme => "Лала.", :number => "2")
    b.title.should eql('КР №2. Лала')

    c = ControlWork.create!(:theme => "Лала.")
    c.title.should eql('Лала')

    d = ControlWork.create!(:theme => "Лала", :variant => "1")
    d.title.should eql('Лала. Вариант 1')

    e = ControlWork.create!(:number => "2", :variant => "1")
    e.title.should eql('КР №2. Вариант 1')
  end
end
