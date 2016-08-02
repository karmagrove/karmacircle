class UsersInvitationsController < Devise::InvitationsController
  
  
  def update
  	# some condition example
    if 1 == 0
      redirect_to root_path
    else
      super
    end
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