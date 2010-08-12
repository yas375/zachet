require 'spec_helper'

describe Content::Synopsis do
  it "should create valid synopsis" do
    Factory(:content_synopsis, :author => mock_model(User), :discipline => mock_model(Discipline))
  end

  context 'validations' do
    it "should require some fields" do
      should validate_presence_of :title, :body, :author, :discipline
    end
  end
end
