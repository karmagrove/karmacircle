class UsersInvitationsController < Devise::InvitationsController
  
  
  def update
  	# some condition example
    if 1 == 0
      redirect_to root_path
    else
      super
    end
  end

  def edit
    # iNc5nZtEnBvUXaZQqCyy
    #current_user = User.where(:invitation_token => params['invitation_token']).limit(1)
    super
  end

  def create
  	@user ||= User.create(:role => "patron")
    Rails.logger.info("params[:user][:role]")
    Rails.logger.info(params[:user][:role])
    if params[:user][:role] 
      @user.role = params[:user][:role]
      @user.save
      Rails.logger.info "saved user @user #{@user.role}"
    end
    current_user.invitations_count +=1
    current_user.save
    @notice = "new user created"
  	super
    # redirect_to root_path

  end

  def new
    # params = secure_params
    @user ||= User.new
    # render 
    @accepted_invitation_count = current_user.invitations_accepted
    if @accepted_invitation_count > 0
      @accepted_user_emails = User.where(:invited_by_id => current_user.id)
    end
    respond_to do |format|
        format.html { render "/users/invitations/new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    
    #super 
    # @user_invitation = User.innivte.new
  end

  private
   def resource_params
     params.permit(user: [:name, :email,:invitation_token, :your_params_here])[:user]
   end

  def secure_params
    params.require(:user).permit(:business_name, :donation_rate, :role)
  end
end