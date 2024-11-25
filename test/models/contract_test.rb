require "test_helper"

class ContractTest < ActiveSupport::TestCase
  test "basic fixture contract validates" do
    contract = contracts(:basic_contract)

    assert contract.valid?
    assert contract.documents.all? { _1.file.attached? }
  end
end
