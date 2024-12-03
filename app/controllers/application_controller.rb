class ApplicationController < ActionController::Base
  include Pundit::Authorization
  after_action :verify_pundit_authorization, unless: :devise_controller?
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def verify_pundit_authorization
    if %w[ new create show update edit destroy approve ].include?(action_name)
      verify_authorized
    else
      verify_policy_scoped
    end
  end
end
