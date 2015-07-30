class ContentController < ApplicationController
  before_action :authenticate_user!

  def charity
    redirect_to root_path, :notice => "Access denied." unless current_user.charity?
  end

  def patron
    redirect_to root_path, :notice => "Access denied." unless current_user.patron?
  end

  def partner
    redirect_to root_path, :notice => "Access denied." unless current_user.partner?
  end

end
