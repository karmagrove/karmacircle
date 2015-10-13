class ChargesController < ApplicationController


def index
  Stripe.api_key = current_user.access_code
  @customers = Stripe::Customer.all(:limit => 3)
  @charges = Stripe::Charge.all
  Rails.logger.info(@charges.inspect)
end

def new
end

def create
  # Amount in cents
  #@amount = (params[:amount].to_f * 100).to_i
  @amount = params[:amount]
  Rails.logger.info("@amount:#{@amount}")
  Stripe.api_key = ENV['STRIPE_API_KEY']
  #Stripe.api_key = "sk_test_B5RUJ3ZgW7BnB5VKp1vNbE7e"
  token = params[:stripeToken]
  
  customer = Stripe::Customer.create({
      :email => params[:stripeEmail],
      :card  => params[:stripeToken]
      },
    {:stripe_account => current_user.uid}
  )
  description = params[:description]

# Create the charge on Stripe's servers - this will charge the user's card
  Rails.logger.info "current_user.email #{current_user.email}"
  Rails.logger.info "params #{params.inspect}"

  ## current_user.calculate_application_fee
  application_fee = current_user.transaction_cost
  donation_amount = (@amount*(current_user.donation_rate/100.to_f)).to_i
  Rails.logger.info("current_user.donation_rate: ")
  Rails.logger.info("donation_amount #{donation_amount}")
  application_fee = application_fee + donation_amount
  Rails.logger.info("application_fee #{application_fee}")
  if (current_user.email == "joshua@karmagrove.com") or (current_user.email == "joshua.montross@gmail.com") then
    charge = Stripe::Charge.create({
    :amount => @amount, # amount in cents
    :currency => "usd",
    :customer => customer,
    :description => description
  },
  {:stripe_account => current_user.uid}
  )
  else
    application_fee = current_user.transaction_cost
    donation_amount = (@amount*(current_user.donation_rate/100.to_f)).to_i
    Rails.logger.info("donation_amount #{donation_amount}")
    application_fee = application_fee + donation_amount
    ## to make the donations come out with the application fee. 
    charge = Stripe::Charge.create({
    :amount => @amount, # amount in cents
    :currency => "usd",
    :customer => customer,
    :description => description,
    :application_fee => application_fee, # amount in cents
  },
  {:stripe_account => current_user.uid}
  )
  
  end
  Rails.logger.info "charge.inspect"
  Rails.logger.info charge.inspect
  donation_amount = (charge.amount*(current_user.donation_rate/100.to_f)).to_i
  Rails.logger.info("donation_amount: #{donation_amount}")
  charity_id = current_user.charity_users.first.charity_id
  # Donation.where
  @donorCharge = DonationCharge.new(donation_amount: donation_amount, 
    payment_reference: charge.id, charity_id: charity_id, 
    revenue: charge.amount, customer_id: customer.id, 
    user_id:current_user.id)
  Rails.logger.info "donorcharge.inspect"
  Rails.logger.info @donorCharge.inspect
  @user = current_user
  if @donorCharge.save(:status => "pending")
    UserMailer.send_receipt(params[:stripeEmail],@donorCharge).deliver
    UserMailer.send_receipt_copy(params[:stripeEmail],@donorCharge).deliver
    redirect_to "/",  notice: 'Charge made'
    #format.html { redirect_to "/", notice: 'Charge made'}
    #format.json { render :show, status: :created, location: @user }
  else
     format.html { redirect_to @user, notice: 'Charge failed' }
     format.json { render json: @user.errors, status: :unprocessable_entity }
  end

rescue Stripe::CardError => e
  flash[:error] = e.message
  redirect_to charges_path
end

private
  
  def secure_params
    params.require(:donor_charge).permit(:donation_amount,
    :payment_reference, :charity_id, :revenue, :customer_id, :user_id)
  end


end