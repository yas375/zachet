require 'spec_helper'

describe Material do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :author_id => 1,
      :discipline_id => 1,
      :commented => false,
      :published => false,
      :promoted => false,
      :data => 
    }
  end

  it "should create a new instance given valid attributes" do
    Material.create!(@valid_attributes)
  end
end
