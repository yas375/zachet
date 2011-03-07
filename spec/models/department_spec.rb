require 'spec_helper'

describe Department do
  it "should create valid department" do
    Department.create!(:name => "name",
                       :abbr => "abbr",
                       :faculty => mock_model(Faculty))
  end

  context "validations" do
    context "presence" do
      it { should validate_presence_of(:faculty_id) }
      it { should validate_presence_of(:name) }
    end

    context "uniqueness" do
      before(:each) do
        faculty = Factory(:faculty, :college => Factory(:college))
        Factory(:department, :faculty => faculty)
      end
      it { should validate_uniqueness_of(:name).scoped_to(:faculty_id).case_insensitive }
    end
  end
end
