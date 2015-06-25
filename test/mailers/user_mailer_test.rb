require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  
  test "account_activation" do
    user = users(:brock)
    # Add activation token to fixture user
    user.activation_token = User.new_token
    # Set mail variable equal to standard account activation email
    mail = UserMailer.account_activation(user)
    # Verify that subject of email is equal to "Account activation"
    assert_equal "Account activation", mail.subject
    # Verify that email is sent to correct user
    assert_equal [user.email], mail.to
    # Verify that email is sent from correct address
    assert_equal ["noreply@pipr.com"], mail.from
    # Verify that name, activation token, and escaped email appear in email body
    assert_match user.name,               mail.body.encoded
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded
  end

  test "password_reset" do
    user = users(:brock)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal "Password reset", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@pipr.com"], mail.from
    assert_match user.reset_token,        mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded
  end

end
