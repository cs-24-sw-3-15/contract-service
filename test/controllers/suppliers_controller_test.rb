require "test_helper"

class SuppliersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    sign_in users(:legal_user)
    get suppliers_path
    assert_response :success
  end

  test "should get new" do
    sign_in users(:legal_user)
    get new_supplier_path
    assert_response :success
  end
end
