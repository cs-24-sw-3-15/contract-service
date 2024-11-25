require "test_helper"

class ContractsControllerTest < ActionDispatch::IntegrationTest
  test "basic user only has access to own contracts" do
    sign_in users(:basic_user)

    # TODO: Stub view from generating? Slows down test.
    get contracts_path

    assert assigns(:contracts).all? { |contract| contract.created_by == users(:basic_user) },
      "Not all contracts belong to the basic user"
  end

  test "admin user has access to basic user contracts" do
    sign_in users(:admin_user)

    # TODO: Stub view from generating? Slows down test.
    get contracts_path

    assert assigns(:contracts).any? { |contract| contract.created_by == users(:basic_user) },
      "Admin does not have access to basic_user's contract"
  end
end
