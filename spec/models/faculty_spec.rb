require 'spec_helper'
describe Faculty do
  it "should create valid faculty" do
    Factory(:faculty, :college => mock_model(College))
  end

  context 'validations' do
    context "presence" do
      it { should validate_presence_of(:college) }
      it { should validate_presence_of(:name) }
    end

    context "uniqueness" do
      before(:each) { Factory(:faculty, :college => mock_model(College)) }
      it { should validate_uniqueness_of(:name).scoped_to(:college_id).case_insensitive }
    end
  end
end
