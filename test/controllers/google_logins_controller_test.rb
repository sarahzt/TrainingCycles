require 'test_helper'

class GoogleLoginsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get failure" do
    get :failure
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

end
