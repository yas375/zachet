require File.dirname(__FILE__) + '/../spec_helper'

describe Topic do
  it "should be valid" do
    Topic.new.should be_valid
  end
end
