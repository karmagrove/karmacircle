class CharitiesController < ApplicationController
  before_action :set_charity, only: [:show, :edit, :update, :destroy]
  before_action :admin_only, :except => [:new, :index, :create]
  #before_action :plan_only, :new, :except => [:index]
  def admin_only
      @charity ||= Charity.find(params[:id])
      unless current_user && (current_user.admin? or current_user.charity.id == @charity.id)
        if request.env["HTTP_REFERER"]
          redirect_to :back, :alert => "Access denied."
        else
          redirect_to "/", :alert => "Access denied."
        end
      end
  end


  def set_charity
    @charity = Charity.find(params[:id])
  end
  # GET /charities
  def charity_params
      params.require(:charity).permit(:name, :description, :url, :stripe_id, :email, :city, :state)
    end
  # GET /charities.json
  def index
    @charities = Charity.all.sort_by {|c| c.status}
  end

  # GET /charities/1
  # GET /charities/1.json
  def show
    @charity = Charity.find(params[:id])
  end

  # GET /charities/new
  def new
    @current_user = current_user
    @charity = Charity.new
  end

  # GET /charities/1/edit
  def edit
  end

  # POST /charities
  # POST /charities.json
  def create
    # charity_params = params[:charity]
    Rails.logger.info charity_params

    Rails.logger.info ("user id params[:user_id]")
    @charity = Charity.new(charity_params)
    email = charity_params[:email]
    if (User.find_by_email(email)) and current_user.email != email
    then
      set_flash_message :notice, "email taken" and redirect_to("/users")
    
    elsif params[:charity_admin] 
      @charity = Charity.new
      @charity.update(charity_params)
      @charity.charity_users.create!(:user_id => current_user.id,:role => 'admin')

    else
      #user = User.new      
      user = User.create(:email => email,:password => "123324324234dfadsfsad")
      if params[:role] == "charity_admin"
        user.role = role
      end
      user.save
      inviter||= params[:user_id]
      invite = UserInvite.create(:user_id=> inviter, :invitee => user.id)
      invite.save
    end

    respond_to do |format|
      if @charity.save
        format.html { redirect_to @charity, notice: 'Charity was successfully created.' }
        format.json { render :show, status: :created, location: @charity }
      else
        format.html { render :new }
        format.json { render json: @charity.errors, status: :unprocessable_entity }
      end
  end

  # PATCH/PUT /charities/1
  # PATCH/PUT /charities/1.json
  def update
    respond_to do |format|
      if @charity.update(charity_params)
        format.html { redirect_to @charity, notice: 'Charity was successfully updated.' }
        format.json { render :show, status: :ok, location: @charity }
      else
        format.html { render :edit }
        format.json { render json: @charity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /charities/1
  # DELETE /charities/1.json
  def destroy
    @charity.destroy
    respond_to do |format|
      format.html { redirect_to charities_url, notice: 'Charity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def admin_only
      unless current_user.admin?
        redirect_to :back, :alert => "Access denied."
      end
  end

  def set_charity
    @charity = Charity.find(params[:id])
  end


  def charity_params
      params.require(:charity).permit(:name, :description, :url, :stripe_id, :email, :city, :state,:user_id)
  end

  def private
    def set_charity
      @charity = Charity.find(params[:id])
    end

    # Use callbacks to share common setup or constraints between actions.

    def plan_only
      unless current_user
        redirect_to "/", :alert => "Access denied. You must be a member to suggest a charity.  Explore with us as a member now for free."
      end
    end


    def admin_only
      unless current_user.admin?
        redirect_to :back, :alert => "Access denied."
      end
    end
  
    # Never trust parameters from the scary internet, only allow the white list through.
    def charity_params
      params.require(:charity).permit(:name, :description, :url, :stripe_id, :email, :city, :state, :user_id)
    end
  end
  end
end

