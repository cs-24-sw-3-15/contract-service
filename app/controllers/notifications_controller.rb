class NotificationsController < ApplicationController
  def index
    @expiring_contracts = policy_scope(Contract).where("end_date <= ?", Time.zone.now + 31.days)
  end
end
