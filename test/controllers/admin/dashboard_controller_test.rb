require "test_helper"

class Admin::DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = admins(:one)
  end

  test "should get index" do
    sign_in @admin

    get admin_dashboard_index_url
    assert_response :success
  end
end
