class ChargesController < ApplicationController


def new
end

def create
  # Amount in cents
  @amount = 500

  customer = Stripe::Customer.create(
    :email => 'example@stripe.com',
    :card  => params[:stripeToken]
  )

  Stripe.api_key = PLATFORM_SECRET_KEY
  token = params[:stripeToken]

# Create the charge on Stripe's servers - this will charge the user's card
  charge = Stripe::Charge.create({
    :amount => 1000, # amount in cents
    :currency => "usd",
    :source => token,
    :description => "Example charge",
    :application_fee => 100 # amount in cents
  },
  {:stripe_account => CONNECTED_STRIPE_ACCOUNT_ID}
  )

  # charge = Stripe::Charge.create(
  #   :customer    => customer.id,
  #   :amount      => @amount,
  #   :description => 'Rails Stripe customer',
  #   :currency    => 'usd'
  # )

rescue Stripe::CardError => e
  flash[:error] = e.message
  redirect_to charges_path
end



end
