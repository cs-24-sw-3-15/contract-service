class DashboardController < ApplicationController
  before_action :authenticate_user!
  # WARN: Add a authorization scope to dashboard when implemented.
  skip_after_action :verify_pundit_authorization

  def index
    today = Date.today
    four_weeks_ahead = today + 4.weeks

    @soon_active_contracts = policy_scope(Contract).where(start_date: today..four_weeks_ahead)
    @soon_expiring_contracts = policy_scope(Contract).where(end_date: today..four_weeks_ahead)
  end
end
