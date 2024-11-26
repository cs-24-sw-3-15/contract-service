class ExpireContractJob < ApplicationJob
  queue_as :default

  def perform(contract_id)
    contract = Contract.find(contract_id)
    return if contract.expired?

    wait_time = contract.end_date.to_time - Time.current
    if wait_time > 0
      ExpireContractJob.set(wait_until: contract.end_date.to_time).perform_later(contract_id)
    else
      contract.expire
      contract.save
    end
  end
end
