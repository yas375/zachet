require 'test_helper'

class CollegeTest < ActiveSupport::TestCase
  fixtures :colleges

  test "invalid with empty attributes" do
    college = College.new
    assert !college.valid?
    assert college.errors.invalid?(:abbr)
    assert college.errors.invalid?(:name)
    assert college.errors.invalid?(:subdomain)
  end

  test "invalid uniqueness" do
    # the same values of fields and with changed registry
    ########## ABBR
    college = College.new(:abbr => colleges(:bsu).abbr, :name => 'Имя второго БГУ', :subdomain => 'asd')
    assert !college.save
    assert_equal I18n.translate('activerecord.errors.messages')[:taken], college.errors.on(:abbr)

    college = College.new(:abbr => colleges(:bsu).abbr.downcase, :name => 'Имя второго БГУ', :subdomain => 'asd')
    assert !college.save
    assert_equal I18n.translate('activerecord.errors.messages')[:taken], college.errors.on(:abbr)

    ########## NAME
    college = College.new(:abbr => 'БГУЫЫ', :name => colleges(:bsu).name.upcase, :subdomain => 'asd')
    assert !college.save
    assert_equal I18n.translate('activerecord.errors.messages')[:taken], college.errors.on(:name)

    college = College.new(:abbr => 'БГУЫЫ', :name => colleges(:bsu).name, :subdomain => 'asd')
    assert !college.save
    assert_equal I18n.translate('activerecord.errors.messages')[:taken], college.errors.on(:name)

    ########## NAME
    college = College.new(:abbr => 'БГУЫ', :name => 'Имя второго БГУф', :subdomain => colleges(:bsu).subdomain.upcase)
    assert !college.save
    assert_equal I18n.translate('activerecord.errors.messages')[:taken], college.errors.on(:subdomain)

    college = College.new(:abbr => 'БГУЫ', :name => 'Имя второго БГУф', :subdomain => colleges(:bsu).subdomain)
    assert !college.save
    assert_equal I18n.translate('activerecord.errors.messages')[:taken], college.errors.on(:subdomain)
  end
end
