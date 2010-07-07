require 'spec_helper'
describe Faculty do
  it "should create valid faculty" do
    Factory(:faculty, :college => mock_model(College))
  end

  context 'validations' do
    it "should require college and name" do
      should validate_presence_of :college, :name
    end

    it "should require unique name for each college" do
      Factory(:faculty, :college => mock_model(College))
      should validate_uniqueness_of :name, :scope => :college_id, :case_sensitive => false
    end
  end
end
