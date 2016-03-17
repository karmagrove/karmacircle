class DonationsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only, :except => :index
  
  def index
    if current_user and current_user.access_code
    Stripe.api_key = current_user.access_code
    @customers = Stripe::Charge.all()
    else
    @donations = Donation.all
    end
    @donations = Donation.all
  end
  
  def make_payments
    Donation.make_payments
  end
  
  def show
    @user = Donation.find(params[:id])
  end
  
  
  private
  
  def admin_only
    unless current_user.admin?
      redirect_to :back, :alert => "Access denied."
    end
  end

end