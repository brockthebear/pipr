require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:brock)
  end
  
  test "login with invalid information" do 
    # Visit login path 
    get login_path
    # Verify that new sessions form renders properly
    assert_template 'sessions/new'
    # Post to the sessions path with an invalid params hash
    post login_path, session: { email: "", password: "" }
    # Verify that new sessions form is re-rendered
    assert_template 'sessions/new'
    # Verify that error messages are displayed
    assert_not flash.empty?
    # Visit another page (i.e., the home page)
    get root_path
    # Verify that the flash message doesn't appear on the new page
    assert flash.empty?
  end
  
  test "login with valid information followed by logout" do 
    # Visit login path
    get login_path 
    # Post valid information to the sessions path 
    post login_path, session: { email: @user.email, password: 'password' }
    # Assert that user is logged in
    assert is_logged_in?
    # Check the right redirect target
    assert_redirected_to @user
    # Visit the target page 
    follow_redirect!            
    assert_template 'users/show'
    #Verify that the login link disappears. 
    assert_select "a[href=?]", login_path, count: 0
    # Verify that a logout link appears 
    assert_select "a[href=?]", logout_path
    # Verify that a profile link appears 
    assert_select "a[href=?]", user_path(@user)
    # Issue a DELETE request to the logout path. 
    delete logout_path
    # Verify that the user is logged out
    assert_not is_logged_in?
    # Verify that the user is returned to the home page
    assert_redirected_to root_url
    # Simulate a user clicking logout in a second window
    delete logout_path
    # Visit the home page
    follow_redirect!
    # Verify that login link reappears
    assert_select "a[href=?]", login_path
    # Verify that logout link disappears
    assert_select "a[href=?]", logout_path,      count: 0
    # Verify that profile links disappear
    assert_select "a[href=?]", user_path(@user), count: 0
  end 
  
  # Verify that user has been remembered
  test "login with remembering" do 
    log_in_as(@user, remember_me: '1')
    assert_not_nil cookies['remember_token']
  end 
  
  # Verify that user has not been remembered
  test "login without remembering" do 
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end 
  
end
