require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", 
                    email: "user@example.com",
                    password: "foobar",
                    password_confirmation: "foobar")
  end

  test "should be valid" do 
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end
  
  test "name should not be more than 50 characters" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "email should not more than 255 characters" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "email validation should accept valid addresses" do 
    valid_addresses = %w[user@example.com USER@foo.com A_US-ER@goo.bar.org first.last@foo.jp alive+bob@bax.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert@user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  test "password should have a minimum length of 6" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
  
  test "associated microposts should be destroyed" do 
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
  
  test "should follow and unfollow a user" do
    brock = users(:brock)
    hodor  = users(:hodor)
    assert_not brock.following?(lana)
    brock.follow(hodor)
    assert brock.following?(hodor)
    assert hodor.followers.include?(brock)
    brock.unfollow(hodor)
    assert_not brock.following?(hodor)
  end
  
  test "feed should have the right posts" do
    brock  = users(:brock)
    hodor   = users(:hodor)
    walt    = users(:walt)
    # Posts from followed user
    walt.microposts.each do |post_following|
      assert brock.feed.include?(post_following)
    end
    # Posts from self
    brock.microposts.each do |post_self|
      assert brock.feed.include?(post_self)
    end
    # Posts from unfollowed user
    hodor.microposts.each do |post_unfollowed|
      assert_not brock.feed.include?(post_unfollowed)
    end
  end

end
