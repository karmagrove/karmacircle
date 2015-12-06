class UsersController < ApplicationController
  before_action :authenticate_user!, :except => :show 
  before_action :admin_only, :except => :show

  def index
    @users = User.all
  end

  def show
    if params[:id]
      @user = User.find(params[:id])
    end
    if params[:business_name]  
      @user = User.find_by_business_name(params[:business_name])
    end

    unless current_user and current_user.admin?
      if (params[:id] && @user != current_user)
        redirect_to :back, :alert => "Access denied."
      end
      unless @user
        redirect_to "/", :alert => "User with name #{params[:business_name]} Not Found."
      end
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(secure_params)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  private

  def admin_only
    unless current_user.admin?
      redirect_to :back, :alert => "Access denied."
    end
  end

  def secure_params
    params.require(:user).permit(:role, :donation_rate,:business_name)
  end

end
