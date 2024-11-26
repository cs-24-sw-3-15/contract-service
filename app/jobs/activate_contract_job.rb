class ActivateContractJob < ApplicationJob
  queue_as :default

  def perform(contract_id)
    contract = Contract.find(contract_id)
    return if contract.active?
    if contract.may_enqueue?
      contract.enqueue
      contract.save
    end

    wait_time = contract.start_date.to_time - Time.current
    if wait_time > 0
      ActivateContractJob.set(wait_until: contract.start_date.to_time).perform_later(contract_id)
    else
      contract.activate
      contract.save
    end
  end
end
