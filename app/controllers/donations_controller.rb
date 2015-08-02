class DonationsController < ApplicationController


def index
  Stripe.api_key = current_user.access_code
  @customers = Stripe::Charges.all()
  #@donations = Donation
end

end