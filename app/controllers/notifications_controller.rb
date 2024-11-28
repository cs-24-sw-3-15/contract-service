class NotificationsController < ApplicationController
  def index
    @expiring_contracts = Contract.where('expiry_date >= ?', time.zone.now + 7.days)
  end
end
