require "test_helper"

class ContractPolicyTest < ActiveSupport::TestCase
  setup do
    @user1 = create(:user)
    @contract1 = create(:contract, created_by: @user1)

    @user2 = create(:user)
    @contract2 = create(:contract, created_by: @user2)

    @privileged_user = create(:user, :admin)
    @privileged_policy = create(:contract, created_by: @privileged_user)
  end


  test "user can create their own contract" do
    assert ContractPolicy.new(@user1, @contract1).create?
    assert ContractPolicy.new(@user2, @contract2).create?
  end

  test "user can not create another user's contract" do
    assert_not ContractPolicy.new(@user1, @contract2).create?
    assert_not ContractPolicy.new(@user2, @contract1).create?
  end

  test "privileged user can create their own contract" do
    assert ContractPolicy.new(@privileged_user, @privileged_policy).create?
  end

  test "privileged user can create another user's contract" do
    assert ContractPolicy.new(@privileged_user, @contract1).create?
    assert ContractPolicy.new(@privileged_user, @contract2).create?
  end
end
