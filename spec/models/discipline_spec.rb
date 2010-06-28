require 'spec_helper'

describe Discipline do
  fixtures :colleges

  before(:each) do
  end

  it "name should be uniq for college" do
    @disp_1 = Discipline.new
    @disp_1.name = 'Высшая математика'
    @disp_1.college = College.first
    @disp_1.should be_valid
    @disp_1.save

    @disp_2 = Discipline.new
    @disp_2.name = 'Высшая математика'
    @disp_2.college = College.first
    @disp_2.should_not be_valid

    @disp_2.college = College.last
    @disp_2.should be_valid
  end
end
