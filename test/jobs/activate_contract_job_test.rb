require "test_helper"

class ActivateContractJobTest < ActiveJob::TestCase
  # integration tests
  test "update in future should set state to queued" do
    contract = Contract.new(
      title: "Test Contract",
      documents: [ documents(:basic_document) ],
      created_by: users(:basic_user),
      start_date: 1.day.from_now,
    )

    assert_enqueued_jobs 1 do
      contract.save!
    end

    # HACK: This bypasses wait_until method and instead hits the return guard in perform().
    perform_enqueued_jobs

    contract.reload
    assert_equal "queued", contract.state
  end

  test "update in past should set state to active" do
    contract = Contract.new(
      title: "Test Contract",
      documents: [ documents(:basic_document) ],
      created_by: users(:basic_user),
    )

    assert_no_enqueued_jobs do
      contract.save!
    end

    assert_enqueued_jobs 1 do
      contract.update!(start_date: 1.day.ago)
    end

    # HACK: This bypasses wait_until method and instead hits the return guard in perform().
    perform_enqueued_jobs

    assert_performed_jobs 1

    contract.reload
    assert_equal "active", contract.state
  end

  # unit tests
  test "should queue job only after save" do
    contract = Contract.new(
      title: "Test Contract",
      documents: [ documents(:basic_document) ],
      created_by: users(:basic_user),
      start_date: 1.day.from_now,
    )

    assert_no_enqueued_jobs

    assert_enqueued_with(job: ActivateContractJob) do
      contract.save!
    end
  end
end
