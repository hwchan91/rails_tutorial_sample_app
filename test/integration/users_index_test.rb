require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin     = users(:michael)
    @non_admin = users(:archer)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

  test "does not display unactivated users and display activated users" do
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
    last_page = User.count / 30 + 1
    get users_path, page: last_page
    assert_select 'a[href=?]', user_path(user), count: 0
    #activate account
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    delete logout_path
    log_in_as(@admin)
    get users_path, page: last_page
    assert_select 'a[href=?]', user_path(user)
  end

end
