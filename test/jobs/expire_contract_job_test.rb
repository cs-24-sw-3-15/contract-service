require "test_helper"

class ExpireContractJobTest < ActiveJob::TestCase
  # use above tests as a template to write tests for ExpireContractJob
  # integration tests
  test "should set contract state to expired" do
    contract = Contract.new(
      state: "active",
      start_date: 2.days.ago,
      title: "Test Contract",
      created_by: users(:basic_user),
      )
    contract.documents << documents(:basic_document)
    contract.id = 1
    contract.save!

    contract.update(end_date: 1.day.ago)
    contract.save!

    contract.reload
    contract = Contract.find_by(id: 1)
    assert_equal "expired", contract.state
  end

  # unit tests
  test "should queue job" do
    contract = Contract.new(
      state: "active",
      start_date: Date.yesterday,
      title: "Test Contract",
      created_by: users(:basic_user)
    )
    contract.documents << documents(:basic_document)
    contract.id = 1
    contract.save!

    contract.update(end_date: Date.tomorrow)
    contract.save!

    assert_enqueued_with(job: ExpireContractJob) do
      contract.schedule_expiration
    end
  end
end
