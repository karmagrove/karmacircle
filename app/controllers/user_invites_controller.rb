class UserInvitesController < ApplicationController

	def index
		@invites = current_user.user_invites
	end

	def create
		
	end
end
