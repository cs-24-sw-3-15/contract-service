class DashboardController < ApplicationController
  before_action :authenticate_user!
  # WARN: Add a authorization scope to dashboard when implemented.
  skip_after_action :verify_pundit_authorization

  def index
    @contracts_status = policy_scope(Contract).group(:status).count
    @contracts_approved_state = policy_scope(Contract).approved.group(:state).count
  end
end
