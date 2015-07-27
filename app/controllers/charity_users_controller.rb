class CharityUsersController < ApplicationController
	def new
	end

	def show
	end

	def create
	end

	def index
	  @charity_users = CharityUser.where(:user_id => current_user.id)
	  @charities = Charity.all
	end
end
