# -*- coding: utf-8 -*-
require 'spec_helper'
describe College do
  context "validations" do
    context "presence" do
      it { should validate_presence_of(:abbr) }
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:subdomain) }
    end

    context "uniquieness values" do
      before(:each) { Factory.create(:college) }
      it { should validate_uniqueness_of(:abbr).case_insensitive }
      it { should validate_uniqueness_of(:name).case_insensitive }
      it { should validate_uniqueness_of(:subdomain).case_insensitive }
    end

    it "should allow only a-z for subdomain" do
      college = Factory.build(:college)
      college.should be_valid

      ['as.sa', 'ASD', 'фывф'].each do |sub|
        college.subdomain = sub
        college.should have(1).error_on(:subdomain)
      end
    end
  end
end
