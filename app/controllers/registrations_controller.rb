class RegistrationsController < Devise::RegistrationsController
  include Payola::StatusBehavior
  before_action :cancel_subscription, only: [:destroy]

  def post_explore
    build_resource(sign_up_params)
    #build_resource()
    params[:user][:no_plan_id]=true
    # become_member
    create
  end

  def explore

  end

  def new
    build_resource({})
    unless params[:plan].nil?
      @plan = Plan.find_by!(stripe_id: params[:plan])
      resource.plan = @plan
    end
    yield resource if block_given?
    respond_with self.resource
  end

  def create
    # build_resource(sign_up_params)

    ## all this is to get the damn
    if params[:user][:no_plan_id]
      # params[:user][:role]=1
      (set_flash_message :notice, "email taken" and redirect_to("/explore") and return true) if @user = User.find_by_email(params[:user][:email])
      
        # sign_up(resource_name, resource)
        current_user = User.create!(sign_up_params)
        Rails.logger.info(current_user)
        # become_member
        #sign_up(resource_name, resource)
        build_resource(sign_up_params)
        resource.save
        yield resource if block_given?
        if resource.persisted?
          if resource.active_for_authentication?
            set_flash_message :notice, :signed_up if is_flashing_format?
            current_user.save
            current_user.plan = Plan.find(4)
            current_user.role = "Patron"
            #sign_up(resource_name, resource)
            #become_member
            Rails.logger.info("current_user.inspect")
            Rails.logger.info(current_user.inspect)
            subscribe
          else
             set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
             expire_data_after_sign_in!
             #subscribe
          end
        else
          clean_up_passwords resource
          render json:
            {error: resource.errors.full_messages.to_sentence},
            status: 400
        end 

        #redirect_to "/"
    else
      resource.role = User.roles[plan.stripe_id] unless resource.admin?
      resource.save
      plan = Plan.find_by!(id: params[:user][:plan_id].to_i)
      if resource.role == "charity"
        #something special.
        @charity = Charity.new(:name => params[:charity_name])
        @charity.save
      end 
      yield resource if block_given?
      if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        subscribe
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        subscribe
      end
    else
      clean_up_passwords resource
      render json:
        {error: resource.errors.full_messages.to_sentence},
        status: 400
      end 
    end
  end

  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
  end

  def change_plan
    plan = Plan.find_by!(id: params[:user][:plan_id].to_i)
    unless plan == current_user.plan
      role = User.roles[plan.stripe_id]
      if current_user.update_attributes!(plan: plan, role: role)
        subscription = Payola::Subscription.find_by!(owner_id: current_user.id)
        Payola::ChangeSubscriptionPlan.call(subscription, plan)
        redirect_to edit_user_registration_path, :notice => "Plan changed."
      else
        flash[:alert] = 'Unable to change plan.'
        build_resource
        render :edit
      end
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email,
    :password, :password_confirmation, :plan_id)
  end

  def become_member
    params[:plan] = current_user.plan
    subscription = Payola::CreateSubscription.call(params, current_user)
    current_user.save
  end

  def subscribe
    return if resource.admin?
    params[:plan] = current_user.plan
    subscription = Payola::CreateSubscription.call(params, current_user)
    current_user.save
    render_payola_status(subscription)
  end

  def cancel_subscription
    subscription = Payola::Subscription.find_by!(owner_id: current_user.id, state: 'active')
    Payola::CancelSubscription.call(subscription)
  end

end
