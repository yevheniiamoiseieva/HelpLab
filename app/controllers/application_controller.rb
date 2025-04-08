class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_user_confirmation
  def after_sign_in_path_for(resource)
    dashboard_path
  end
  protected
  def check_user_confirmation
    if user_signed_in? && !current_user.confirmed?
      sign_out current_user
      redirect_to new_user_session_path, alert: "Please confirm your email address"
    end
  end
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password])
  end
end
