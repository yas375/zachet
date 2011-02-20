require 'spec_helper'

describe Department do
  before(:each) do
    @valid_attributes = {
      :name => "name",
      :abbr => "abbr",
      :faculty => mock_model(Faculty)
    }
  end

  it "should create valid department" do
    Department.create!(@valid_attributes)
  end

  context "validations" do
    it "should require faculty and name" do
      should validate_presence_of :faculty_id, :name
    end

    it "should require unique name for each college" do
      faculty = Factory(:faculty, :college => Factory(:college))
      Factory(:department, :faculty => faculty)
      should validate_uniqueness_of :name, :scope => :faculty_id, :case_sensitive => false
    end
  end
end
