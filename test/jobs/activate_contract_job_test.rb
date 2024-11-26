require "test_helper"

class ActivateContractJobTest < ActiveJob::TestCase
  # integration tests
  test "should set contract state to queued" do
    contract = Contract.new(
      title: "Test Contract",
      created_by: users(:basic_user),
      )
    contract.documents << documents(:basic_document)
    contract.id = 1
    contract.save!

    contract.update(start_date: 1.day.from_now)
    contract.save!

    contract.reload
    contract = Contract.find_by(id: 1)
    assert_equal "queued", contract.state
  end

  test "should set contract state to active" do
    contract = Contract.new(
      title: "Test Contract",
      created_by: users(:basic_user),
      )
    contract.documents << documents(:basic_document)
    contract.id = 2
    contract.save!

    contract.start_date = 1.day.ago
    contract.save!

    contract.reload
    contract = Contract.find_by(id: 2)
    assert_equal "active", contract.state
  end

  # unit tests
  test "should queue job" do
    contract = Contract.new(
      start_date: 1.day.from_now,
      title: "Test Contract",
      created_by: users(:basic_user),
      )
    contract.documents << documents(:basic_document)
    contract.id = 1
    contract.save!

    assert_enqueued_with(job: ActivateContractJob) do
      contract.schedule_activation
    end
  end
end

