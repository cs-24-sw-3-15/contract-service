class DashboardController < ApplicationController
  before_action :authenticate_user!
  # WARN: Add a authorization scope to dashboard when implemented.
  skip_after_action :verify_pundit_authorization

  def index
    @contracts_status = policy_scope(Contract).group(:status).count
    @contracts_approved_state = policy_scope(Contract).approved.group(:state).count

    tomorrow = Date.tomorrow
    four_weeks_ahead = tomorrow + 4.weeks

    @soon_active_contracts = policy_scope(Contract).where(start_date: tomorrow..four_weeks_ahead).order(:start_date)
    @soon_expiring_contracts = policy_scope(Contract).where(end_date: tomorrow..four_weeks_ahead).order(:end_date)
  end
end
