require 'test_helper'

class CollegesCellTest < ActionController::TestCase
  include Cells::AssertionsHelper
  
    test "list" do
    html = render_cell(:colleges, :list)
    #assert_selekt html, "div"
  end
  
  
end