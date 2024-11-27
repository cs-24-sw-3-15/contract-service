require "test_helper"

class SuppliersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get suppliers_index_url
    assert_response :success
  end

  test "should get new" do
    get suppliers_new_url
    assert_response :success
  end

  test "should get create" do
    get suppliers_create_url
    assert_response :success
  end
end
