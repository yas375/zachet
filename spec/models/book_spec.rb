require 'spec_helper'

describe Book do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :name => "value for name",
      :authors => "value for authors",
      :publishing_company => "value for publishing_company",
      :year => "value for year",
      :contents => "value for contents",
      :description => "value for description"
    }
  end

  it "should create a new instance given valid attributes" do
    Book.create!(@valid_attributes)
  end
end
