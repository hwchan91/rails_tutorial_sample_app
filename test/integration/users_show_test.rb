require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:michael)
  end

  test "redirect unactivated users to root" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Activation Test",
                                         email: "mail@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    log_in_as(@admin)
    get user_path(user)
    assert_redirected_to root_url
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_select 'h1', text: "Activation Test"
  end

end
