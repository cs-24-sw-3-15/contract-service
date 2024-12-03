class DashboardController < ApplicationController
  before_action :authenticate_user!
  # WARN: Add a authorization scope to dashboard when implemented.
  skip_after_action :verify_pundit_authorization

  def index
    @contracts_pending = policy_scope(Contract)
                                 .where(status: :pending)
                                 .group(:status)
                                 .count

    @contracts_expired = policy_scope(Contract)
                                 .where(state: [ :active, :expired ])
                                 .group(:state)
                                 .count

   @contracts_data = @contracts_pending.merge(@contracts_expired) { |key, pending_count, expired_count| pending_count + expired_count }
  end
end
