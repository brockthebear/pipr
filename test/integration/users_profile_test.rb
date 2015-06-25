require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  # Allows access to full_title helper
  include ApplicationHelper
  
  def setup
    @user = users(:hodor)
  end
  
  test "profile display" do
    # Go to the user profile page
    get user_path(@user)
    assert_template 'users/show'
    # Verify that page title is present
    assert_select 'title', full_title(@user.name)
    # Verify that the user's username and profile picture displays
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    # Verify that the number of microposts appears somewhere on the page
    assert_match @user.microposts.count.to_s, response.body
    # Verify that microposts are displayed as paginated
    assert_select 'div.pagination'
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end 
  end 

end
