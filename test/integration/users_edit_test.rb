require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:brock)
  end 
  
  test "unsuccessful edit" do
    # Log in as test user
    log_in_as(@user)
    # Get edit page
    get edit_user_path(@user)
    # Verify that the edit template is rendered
    assert_template 'users/edit'
    # Submission of invalid information
    patch user_path(@user), user: { name:                  "",
                                    email:                 "user@invalid",
                                    password:              "foo",
                                    password_confirmation: "bar" }
    # Verify that the edit page is re-rendered after submission
    assert_template 'users/edit'
  end 
  
  test "successful edit with friendly forwarding" do
    # Get edit page for user
    get edit_user_path(@user)
    # Log in as test user
    log_in_as(@user)
    # Verify that user is redirected to the edit page
    assert_redirected_to edit_user_path(@user)
    # Submission of valid information
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), user: { name: name,
                                    email: email,
                                    password:              "",
                                    password_confirmation: "" }
    # Check for nonempty flash message
    assert_not flash.empty?
    # Verify redirect to the profile page
    assert_redirected_to @user
    # Reload user's value from database
    @user.reload
    # Confirm that user's values were successfully updated
    assert_equal @user.name,  name 
    assert_equal @user.email, email
  end
  
end
