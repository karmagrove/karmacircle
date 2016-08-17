module DevisePermittedParameters
  extend ActiveSupport::Concern

  included do
    before_action :configure_permitted_parameters
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).concat [:name, :role, :avatar]
    # devise_parameter_sanitizer.for(:user_invitation).concat [:name, :role]
    # devise_parameter_sanitizer.for(:account_create) << :role
    # devise_parameter_sanitizer.for(:account_update) << :name
    devise_parameter_sanitizer.for(:send_invitation) do |u|
      u.permit(:email, :role)
    end
    devise_parameter_sanitizer.for(:invite) do |u|
      u.permit(:email, :role)
    end
    
    # devise_parameter_sanitizer.for(:send_invitation) << :role
    # devise_parameter_sanitizer.for(:create_invitation) do |u|
    #   u.permit(:email, :role)
    # end

    # devise_parameter_sanitizer.for(:invitation) do |u|
    #   u.permit(:email, :role)
    # end
    devise_parameter_sanitizer.for(:sign_up) << :role
    devise_parameter_sanitizer.for(:account_update) << :role
    devise_parameter_sanitizer.for(:account_update) << :avatar
    # devise_parameter_sanitizer.for(:create_invitation) << :role

    #add some params
    #devise_parameter_sanitizer.for(:accept_invitation).concat [:first_name, :last_name, :phone]
    
    # over ride params
    devise_parameter_sanitizer.for(:accept_invitation) do |u|
    u.permit(:name, :password, :business_name, :password_confirmation,
             :invitation_token,:role,:avatar)
    end

    devise_parameter_sanitizer.for(:account_update) {|u|
     u.permit(:name,:role, :donation_rate,:business_name,:current_password,:public_profile,:community_profile, :avatar, :currency)
    }

  end

end

DeviseController.send :include, DevisePermittedParameters
