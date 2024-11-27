class ActivateContractJob < ApplicationJob
  queue_as :default

  def perform(contract_id)
    contract = Contract.find(contract_id)

    return unless contract.may_activate?

    contract.activate!
  end
end
