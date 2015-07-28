class CharityUsersController < ApplicationController
	def new
	end

	def show
	end

	def create
	end

	def index
	  if current_user	
	    @charity_users = CharityUser.where(:user_id => current_user.id)
	    @charities = Charity.all
	  else
	  	redirect_to "/"
	  end
	end
end
