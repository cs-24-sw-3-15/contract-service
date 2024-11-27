require "test_helper"

class ExpireContractJobTest < ActiveJob::TestCase
  # use above tests as a template to write tests for ExpireContractJob
  # integration tests
  test "should set contract state to expired in one write" do
    contract = Contract.create(
      state: "active",
      start_date: 2.days.ago,
      title: "Test Contract",
      created_by: users(:basic_user),
      documents: [ documents(:basic_document) ],
    )

    assert_no_enqueued_jobs do
      contract.update! end_date: Date.yesterday.to_datetime
    end

    contract.reload
    assert_equal "expired", contract.state
  end

  test "should schedule expiration on update" do
    contract = Contract.create(
      state: "active",
      start_date: 2.days.ago,
      title: "Test Contract",
      created_by: users(:basic_user),
      documents: [ documents(:basic_document) ],
    )

    assert_enqueued_with job: ExpireContractJob, at: Date.tomorrow.to_datetime do
      contract.update! end_date: Date.tomorrow.to_datetime
    end

    assert_enqueued_jobs 1

    contract.reload
    assert_equal "active", contract.state
  end

  test "should schedule expiration on create" do
    contract = Contract.new(
      state: "active",
      start_date: Date.yesterday.to_datetime,
      end_date: Date.tomorrow.to_datetime,
      title: "Test Contract",
      created_by: users(:basic_user),
      documents: [ documents(:basic_document) ],
    )

    assert_enqueued_with job: ExpireContractJob, at: Date.tomorrow.to_datetime do
      contract.save!
    end

    assert_enqueued_jobs 1

    contract.reload
    assert_equal "active", contract.state
  end
end
