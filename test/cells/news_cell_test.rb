require 'test_helper'

class NewsCellTest < ActionController::TestCase
  include Cells::AssertionsHelper
  
    test "global" do
    html = render_cell(:news, :global)
    #assert_selekt html, "div"
  end
  
    test "local" do
    html = render_cell(:news, :local)
    #assert_selekt html, "div"
  end
  
  
end