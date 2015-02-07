require 'test_helper'

class AsteriskControllerTest < ActionController::TestCase
  test "should get make_call" do
    get :make_call
    assert_response :success
  end

end
