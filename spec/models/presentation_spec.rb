require 'spec_helper'

describe Presentation do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :description => "value for description"
    }
  end

  it "should create a new instance given valid attributes" do
    Presentation.create!(@valid_attributes)
  end
end
