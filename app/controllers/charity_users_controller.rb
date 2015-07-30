class CharityUsersController < ApplicationController
	def new
	end

	def show
	end

	def create
	  @charity_user = CharityUser.new(charity_user_params)
	  @user = current_user
	  respond_to do |format|
        if @charity_user.save
          format.html { redirect_to @user, notice: 'charity was successfully added to your account.' }
          format.json { render :show, status: :created, location: @user }
        else
          format.html { render :new }
          format.json { render json: @seller.errors, status: :unprocessable_entity }
        end
	  end
	end

	def index
	  if current_user	
	    @charity_users = CharityUser.where(:user_id => current_user.id)
	    @charities = Charity.all
	  else
	  	redirect_to "/"
	  end
	end

	private
	  def charity_user_params
        params.require(:charity_user).permit(:role, :user_id, :charity_id)
      end
    
end
