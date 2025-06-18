class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :user_signed_as_admin?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username, :password])
  end

  private
  def user_signed_as_admin?
    return true if user_signed_in? && current_user.role == 'admin'

    false
  end
end
