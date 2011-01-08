# -*- coding: utf-8 -*-
require 'spec_helper'

describe VisitsCounter do
  before(:each) do
    @newsitem = Factory(:newsitem)
    @newsitem.reload
  end

  it "should correct counting visits" do
    5.times { @newsitem.increment_visits }
    @newsitem.visits.should == 5
  end
end
