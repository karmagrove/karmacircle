class ChargesController < ApplicationController


def new
end

def create
  # Amount in cents
  @amount = 500


  #Stripe.api_key = PLATFORM_SECRET_KEY
  Stripe.api_key = "sk_test_B5RUJ3ZgW7BnB5VKp1vNbE7e"
  token = params[:stripeToken]
  
  customer = Stripe::Customer.create({
      :email => params[:stripeEmail],
      :card  => params[:stripeToken]
      },
    {:stripe_account => current_user.uid}
  )

# Create the charge on Stripe's servers - this will charge the user's card
  Rails.logger.info "current_user.email #{current_user.email}"
  if current_user.email == "joshua@karmagrove.com"
    charge = Stripe::Charge.create({
    :amount => 1000, # amount in cents
    :currency => "usd",
    :customer => customer,
    :description => "Example charge"
  },
  {:stripe_account => current_user.uid}
  )
  else
    application_fee = current_user.transaction_cost
    charge = Stripe::Charge.create({
    :amount => 1000, # amount in cents
    :currency => "usd",
    :customer => customer,
    :description => "Example charge",
    :application_fee => application_fee, # amount in cents
  },
  {:stripe_account => current_user.uid}
  )
    Rails.logger.info "charge.inspect"
    Rails.logger.info charge.inspect
  end

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
