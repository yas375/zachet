require 'test_helper'

class DisciplineTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Discipline.new.valid?
  end
end
