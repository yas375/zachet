require 'spec_helper'

describe GraduateWork do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :theme => "value for theme",
      :author => "value for author",
      :year => "value for year",
      :description => "value for description"
    }
  end

  it "should create a new instance given valid attributes" do
    GraduateWork.create!(@valid_attributes)
  end
end
