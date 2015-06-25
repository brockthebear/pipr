require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  
  def setup
    @base_title = "pipr"
  end
  
  test "should get home" do
    # test that the "home" page can be accessed via the GET request
    get :home
    # test that the underlying HTTP status code = 200, or "success"
    assert_response :success
    # tests that the HTML selector "title" contains string "Home | HULK".
    assert_select "title", "#{@base_title}"
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select "title", "#{@base_title}"
  end
  
  test "should get about" do
    get :about
    assert_response :success
    assert_select "title", "#{@base_title}"
  end
  
  test "should get contact" do
    get :contact
    assert_response :success
    assert_select "title", "#{@base_title}"
  end

end
