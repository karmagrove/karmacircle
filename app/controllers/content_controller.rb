class ContentController < ApplicationController
  before_action :authenticate_user!

  def charity
    redirect_to root_path, :notice => "Access denied." unless current_user.charity?

  end

  def patron
    redirect_to root_path, :notice => "Access denied." unless current_user.patron?
    redirect_to "/", :notice => "You are logged in as a Patron"
  end

  def partner
    redirect_to root_path, :notice => "Access denied." unless current_user.partner?
    redirect_to "/", :notice => "You are logged in as a Partner"
  end

end
