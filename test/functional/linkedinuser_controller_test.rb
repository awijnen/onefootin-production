require 'test_helper'

class LinkedinuserControllerTest < ActionController::TestCase
  test "should get show_connections" do
    get :show_connections
    assert_response :success
  end

end
