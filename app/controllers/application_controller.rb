class ApplicationController < ActionController::Base
  include Pundit::Authorization
  after_action :verify_pundit_authorization, unless: :devise_controller?
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # If extra actions are required for another controller:
  # `after_action verify_policy_scoped, only: :custom_endpoint`
  #   - If the endpoint returns a "list" of items, like "pending contracts".
  # `after_action verify_authorized, only: :custom_endpoint`
  #   - Do this for endpoints that handle a single item, like "approve contract".
  def verify_pundit_authorization
    if %w[ index ].include?(action_name)
      verify_policy_scoped
    elsif %w[ new create show edit update destroy ].include?(action_name)
      verify_authorized
    end
  end
end
