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
  	super
  end
end