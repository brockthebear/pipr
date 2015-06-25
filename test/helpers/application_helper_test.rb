require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  
  test "full title helper" do
    assert_equal full_title,         "pipr" 
    assert_equal full_title("Help"), "Help | pipr"
  end
end