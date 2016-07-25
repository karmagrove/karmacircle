module DevisePermittedParameters
  extend ActiveSupport::Concern

  included do
    before_action :configure_permitted_parameters
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    # devise_parameter_sanitizer.for(:account_update) << :name
    # devise_parameter_sanitizer.for(:account_update) << :donation_rate
    # devise_parameter_sanitizer.for(:account_update) << :business_name


    #add some params
    #devise_parameter_sanitizer.for(:accept_invitation).concat [:first_name, :last_name, :phone]
    
    # over ride params
    devise_parameter_sanitizer.for(:accept_invitation) do |u|
    u.permit(:name, :password, :business_name, :password_confirmation,
             :invitation_token)
    end

    devise_parameter_sanitizer.for(:account_update) {|u|
     u.permit(:name,:donation_rate,:business_name,:current_password,:public_profile,:community_profile)
    }

    #devise_parameter_sanitizer.for(:registration) << :business_name
  end

end

DeviseController.send :include, DevisePermittedParameters
