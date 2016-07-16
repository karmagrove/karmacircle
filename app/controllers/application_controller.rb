class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :update_sanitized_params, if: :devise_controller?

  def update_sanitized_params
    #devise_parameter_sanitizer.for(:registration_update) {|u| u.permit(:name,:donation_rate,:business_name)}
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:name,:donation_rate,:business_name, :email, :password, :password_confirmation, :current_password)}
  end

  def after_sign_in_path_for(resource)
    case current_user.role
      when 'admin'
        users_path
      when 'partner'
        content_partner_path
      when 'patron'
        content_patron_path  
      when 'customer'
        content_customer_path
      else
        root_path
    end
  end

end
