# -*- coding: utf-8 -*-
require 'spec_helper'

describe VisitsLog do
  before(:each) do
    @attach = Factory(:attach)
    @attach.reload
    @user = Factory(:user)
    2.times { @attach.add_log(@user, '127.0.0.1') }
  end

  it "should have right log record" do
    @attach.visits_logs.first.user.should == @user
  end

  context "counter" do
    it "should have right visits counter" do
      @attach.visits.should == 2
    end

    it "should have correct visits counter even after user deletion" do
      @user.destroy
      @attach.visits.should == 2
    end
  end
end
