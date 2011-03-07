require 'spec_helper'

describe Discipline do
  it "should create valid discipline" do
    Discipline.create!(:name => "name",
                       :abbr => "abbr",
                       :college => mock_model(College))
  end

  context "validations" do
    context "presence" do
      it { should validate_presence_of(:college) }
      it { should validate_presence_of(:name) }
    end

    context "uniqueness" do
      before(:each) { Factory(:discipline, :college => mock_model(College)) }
      it { should validate_uniqueness_of(:name).scoped_to(:college_id).case_insensitive }
    end
  end
end
