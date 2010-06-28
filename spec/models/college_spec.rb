require 'spec_helper'

describe College do
  fixtures :colleges

  before(:each) do
    @new_college = {:subdomain => 'asd',
                    :abbr => 'АСД',
                    :name => 'Полное Название'}
    @college = College.new(@new_college)
  end

  it "should create new college" do
    @college.should be_valid
  end

  it "subdomain should be uniq and only latic small letters are allowed" do
    @college.subdomain = colleges(:bsu).subdomain.upcase
    @college.should_not be_valid
    @college.errors.on(:subdomain).should_not be_nil

    @college.subdomain = 'ФыAas'
    @college.should_not be_valid
    @college.errors.on(:subdomain).should_not be_nil
  end

  it "abbr and name should be uniq" do
    @college.abbr = colleges(:bsu).abbr.upcase
    @college.should_not be_valid
    @college.errors.on(:abbr).should_not be_nil

    @college.name = colleges(:bsu).name.upcase
    @college.should_not be_valid
    @college.errors.on(:name).should_not be_nil
  end
end
