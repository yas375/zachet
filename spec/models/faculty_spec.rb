require 'spec_helper'
describe Faculty do
  before(:each) do
    @valid_attributes = {
      :name => "name",
      :abbr => "abbr",
      :college => mock_model(College)
    }
  end

  it "should create valid discipline" do
    Faculty.create!(@valid_attributes)
  end

  context 'validations' do
    before(:all) do
      @college = Factory.create(:college)
    end

    it "should require college and name" do
      should validate_presence_of :college, :name
    end

    it "should require unique name for each college" do
      Factory(:faculty, :college => @college)
      should validate_uniqueness_of :name, :scope => :college_id, :case_sensitive => false
    end
  end
end
