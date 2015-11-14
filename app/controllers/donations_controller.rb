class DonationsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only, :except => :index
  
  def index
    if current_user
    Stripe.api_key = current_user.access_code
    @customers = Stripe::Charges.all()
    else
    @donations = Donation
    end
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