require "test_helper"

class ActivateContractJobTest < ActiveJob::TestCase
  # integration tests
  test "update in future should schedule and set state to queued" do
    contract = Contract.new(
      title: "Test Contract",
      documents: [ documents(:basic_document) ],
      created_by: users(:basic_user),
      start_date: Date.tomorrow.to_datetime,
    )

    assert_enqueued_jobs 1 do
      contract.save!
    end

    perform_enqueued_jobs at: Time.now
    assert_performed_jobs 0

    contract.reload
    assert_equal "queued", contract.state
  end

  test "update in past should set state to active" do
    contract = Contract.create(
      title: "Test Contract",
      documents: [ documents(:basic_document) ],
      created_by: users(:basic_user),
    )

    assert_no_enqueued_jobs

    contract.update! start_date: Date.yesterday.to_datetime

    assert_no_enqueued_jobs

    contract.reload
    assert_equal "active", contract.state
  end

  test "should queue job only after save" do
    contract = Contract.new(
      title: "Test Contract",
      documents: [ documents(:basic_document) ],
      created_by: users(:basic_user),
      start_date: Date.tomorrow.to_datetime,
    )

    assert_no_enqueued_jobs

    assert_enqueued_with job: ActivateContractJob do
      contract.save!
    end
  end
end
