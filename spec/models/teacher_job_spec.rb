require 'spec_helper'

describe TeacherJob do
  before(:each) do
    @valid_attributes = {
      :teacher => mock_model(Teacher),
      :college => mock_model(College),
      :department => mock_model(Department)
    }
  end

  it "should create a new instance given valid attributes" do
    TeacherJob.create!(@valid_attributes)
  end

  context "validations" do
    it "should require teacher and college" do
      should validate_presence_of :teacher, :college
    end
  end
end
