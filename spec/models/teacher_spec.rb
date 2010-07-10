require 'spec_helper'

describe Teacher do
  before(:each) do
    @valid_attributes = {
      :first_name => 'Василий',
      :middle_name => 'Иванович',
      :last_name => 'Иванов',
      :email => 'asd@aasd.ru',
      :text => 'Родился в таком-то году в таком-то месте.'
    }
  end

  it "should create a new instance given valid attributes" do
    Teacher.create!(@valid_attributes)
  end

  context "validations" do
    it "should require last_name" do
      should validate_presence_of :last_name
    end
  end
end
