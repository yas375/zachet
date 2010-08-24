require 'spec_helper'

describe Content::Manual do
  it "should create valid manual" do
    Factory(:content_manual, :author => mock_model(User), :discipline => mock_model(Discipline))
  end

  context 'validations' do
    it "should require some fields" do
      should validate_presence_of :title, :body, :author, :discipline
    end
  end
end
