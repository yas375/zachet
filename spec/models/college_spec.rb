require 'spec_helper'
describe College do
  context "validations" do
    it "should require abbr, name and subdomain" do
      should validate_presence_of :abbr, :name, :subdomain
    end

    it "should be uniquieness values of attr, name and subdomain" do
      Factory.create(:college)
      should validate_uniqueness_of :abbr, :name, :subdomain, :case_sensitive => false
    end

    it "should allow only a-z for subdomain" do
      college = Factory.build(:college)
      college.should be_valid

      college.subdomain = 'as.sa'
      college.should have(1).error_on(:subdomain)

      college.subdomain = 'ASD'
      college.should have(1).error_on(:subdomain)

      college.subdomain = 'фыв'
      college.should have(1).error_on(:subdomain)
    end
  end
end
