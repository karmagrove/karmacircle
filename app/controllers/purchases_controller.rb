class PurchasesController < ApplicationController

def create
  # Amount in cents
  #@amount = (params[:amount].to_f * 100).to_i
  if current_user 
    seller = current_user
  else
    seller = User.find(params[:user_id])
  end
  @amount = params[:amount]
  Rails.logger.info("@amount:#{@amount}")
  Stripe.api_key = ENV['STRIPE_API_KEY']
  #Stripe.api_key = "sk_test_B5RUJ3ZgW7BnB5VKp1vNbE7e"
  token = params[:stripeToken]
  
  customer = Stripe::Customer.create({
      :email => params[:stripeEmail],
      :card  => params[:stripeToken]
      },
    {:stripe_account => seller.uid}
  )
  description = params[:description]

# Create the charge on Stripe's servers - this will charge the user's card
  Rails.logger.info "seller.email #{seller.email}"
  Rails.logger.info "params #{params.inspect}"

  ## seller.calculate_application_fee
  application_fee = seller.transaction_cost
  donation_amount = (@amount*(seller.donation_rate/100.to_f)).to_i
  Rails.logger.info("seller.donation_rate: ")
  Rails.logger.info("donation_amount #{donation_amount}")
  application_fee = application_fee + donation_amount
  Rails.logger.info("application_fee #{application_fee}")
  if (seller.email == "joshua@karmagrove.com") or (seller.email == "joshua.montross@gmail.com") then
    charge = Stripe::Charge.create({
    :amount => @amount, # amount in cents
    :currency => "usd",
    :customer => customer,
    :description => description
  },
  {:stripe_account => seller.uid}
  )
  else
    application_fee = seller.transaction_cost
    donation_amount = (@amount*(seller.donation_rate/100.to_f)).to_i
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
  {:stripe_account => seller.uid}
  )
  
  end
  Rails.logger.info "charge.inspect"
  Rails.logger.info charge.inspect
  donation_amount = (charge.amount*(seller.donation_rate/100.to_f)).to_i
  Rails.logger.info("donation_amount: #{donation_amount}")
  charity_id = seller.charity_users.first.charity_id
  # Donation.where
  @donorCharge = DonationCharge.new(donation_amount: donation_amount, 
    payment_reference: charge.id, charity_id: charity_id, 
    revenue: charge.amount, customer_id: customer.id, 
    user_id:seller.id)
  Rails.logger.info "donorcharge.inspect"
  Rails.logger.info @donorCharge.inspect
  @user = seller
  if @donorCharge.save(:status => "pending")
  	@purchase = Purchase.new(:donationcharge_id => @donorCharge.id, :buyer_email => params[:stripeEmail])
    @purchase.save
    UserMailer.send_receipt(params[:stripeEmail],@donorCharge).deliver
    UserMailer.send_receipt_copy(params[:stripeEmail],@donorCharge).deliver
    redirect_to "/",  notice: 'Charge succeeded: check your email'
    #format.html { redirect_to "/", notice: 'Charge made'}
    #format.json { render :show, status: :created, location: @user }
  else
     format.html { redirect_to "/", notice: 'Charge failed' }
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
