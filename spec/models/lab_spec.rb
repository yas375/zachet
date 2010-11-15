require 'spec_helper'

describe Lab do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :theme => "value for theme",
      :number => "value for number",
      :variant => "value for variant",
      :description => "value for description"
    }
  end

  it "should create a new instance given valid attributes" do
    Lab.create!(@valid_attributes)
  end
end
