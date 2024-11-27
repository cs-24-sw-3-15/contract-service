require "test_helper"

class ExpireContractJobTest < ActiveJob::TestCase
  # use above tests as a template to write tests for ExpireContractJob
  # integration tests
  test "should set contract state to expired" do
    contract = Contract.create(
      state: "active",
      start_date: 2.days.ago,
      title: "Test Contract",
      created_by: users(:basic_user),
      documents: [ documents(:basic_document) ],
    )

    contract.update!(end_date: 1.day.ago)

    # HACK: This bypasses wait_until method and instead hits the return guard in perform().
    perform_enqueued_jobs

    contract.reload
    assert_equal "expired", contract.state
  end

  # unit tests
  test "should queue job" do
    contract = Contract.create(
      state: "active",
      start_date: Date.yesterday,
      title: "Test Contract",
      created_by: users(:basic_user),
      documents: [ documents(:basic_document) ],
    )

    assert_enqueued_with job: ExpireContractJob do
      contract.update!(end_date: 1.day.from_now)
    end
  end
end
