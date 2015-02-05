require 'test_helper'

class CookiesControllerTest < ActionController::TestCase
  test "should get set_locale" do
    get :set_locale
    assert_response :success
  end

  test "should get set_contacts_view" do
    get :set_contacts_view
    assert_response :success
  end

end
