class ChargesController < ApplicationController


def index

  if current_user && Stripe.api_key = current_user.access_code
    @charge_fees = {}
    @customers = Stripe::Customer.all(:limit => 3)
    @charges = Stripe::Charge.all(:limit => 100)
    Rails.logger.info(@charges.inspect)
    ## FIND THE DONATIONCHARGE FOR CHARGES ABOVE
    ## DONATIONCHARGE
    @balance = Stripe::Balance#.retrieve
     # @balance.inspect 
    @transfers = Stripe::Transfer.all
    # @transfers.each  do |transfer|
      #Rails.logger.info transfer.inspect
    #end

    @total_donations = current_user.total_donations
    @total_pledged_donations = current_user.total_pledged_donations


    @application_fee = current_user.transaction_cost
    # @charges.each do |charge|
    #   d = DonationCharge.find_by_payment_reference(charge.id)
    #   begin 
    #     fee = Stripe::ApplicationFee.retrieve(charge.application_fee)
    #     @charge_fees[charge.application_fee]= currennt_user.transaction_cost
    #   rescue
    #   end
    #   #Rails.logger.info d.inspect
    # end

  else
    redirect_to "/",  notice: 'You must activate your account before you can view your charges' 
  end

end

def new
end

def create
  # Amount in cents
  #@amount = (params[:amount].to_f * 100).to_i
  status = "failure"
  failure_message = ""
  if current_user 
    seller = current_user
  else
    seller = User.find(params[:user_id])
  end
  @amount = params[:amount]
  Rails.logger.info("@amount:#{@amount},  #{params[:stripeEmail]},
 #{params[:stripeToken]}")
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
  donation_amount = (@amount.to_i*seller.donation_rate/100).to_i
  Rails.logger.info("current_user.calculate_application_fee : #{seller.calculate_application_fee(@amount)}")
  #Rails.logger.info("seller.donation_rate: ")
  Rails.logger.info("donation_amount #{donation_amount}")
  application_fee = application_fee + donation_amount
  Rails.logger.info("application_fee #{application_fee}")
  if (seller.email == "joshua@karmagrove.com") or (seller.email == "joshua.montross@gmail.com") then
    begin
    charge = Stripe::Charge.create({
    :amount => @amount, # amount in cents
    :currency => "usd",
    :customer => customer,
    :description => description
  },
  {:stripe_account => seller.uid}
  )
    
rescue Stripe::CardError => e
  Rails.logger.info("Error in card reader: #{e.message}")
  flash[:error] = e.message
  #flash[:notice] = "The card is not working: #{e.message}"
  #redirect_to charges_path, :notice => "The card is not working: #{e.message}"
  failure_message = e.message
  status = "failure"
  Rails.logger.info "first error"
end
  else
    application_fee = seller.transaction_cost
    donation_amount = (@amount.to_i*seller.donation_rate/100).to_i
    Rails.logger.info("donation_amount #{donation_amount}")
    application_fee = application_fee + donation_amount
    ## to make the donations come out with the application fee. 
    begin
    charge = Stripe::Charge.create({
    :amount => @amount, # amount in cents
    :currency => "usd",
    :customer => customer,
    :description => description,
    :application_fee => application_fee, # amount in cents
  },
  {:stripe_account => seller.uid}
  )

rescue Stripe::CardError => e
  Rails.logger.info("Error in card reader: #{e.message}")
  flash[:error] = e.message
  # flash[:notice] = "The card is not working: #{e.message}"
 # redirect_to charges_path, :notice => "The card is not working: #{e.message}"
  status = "failure"
  failure_message = e.message
end
  
  end

  if charge and charge.status == "succeeded"
    status = "success"
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
  else
    status = "failure"
    if charge
      failure_message ||= charge.failure_message
    end
  end

    if status == "success" and @donorCharge.save(:status => "pending")
      customer= {}
      customer[:stripeEmail] = params[:stripeEmail]
      UserMailer.send_receipt(params[:stripeEmail],@donorCharge).deliver
      UserMailer.send_receipt_copy(customer,@donorCharge).deliver
      #notice = 'Charge success - you should have an email receipt' at #{customer[:stripeEmail]}
      redirect_to "/",  notice: 'Charge success - you should have an email receipt'
      # respond_to do |format|
      #   # recent change to make customer obvious they have bought
      #   format.html { redirect_to "/success", notice: 'Charge made'}
      #   format.json { render json: {:status => "success"} }
      # end
    else
       Rails.logger.info "redirect_to with notice Charge failed: #{failure_message}"
       #redirect_to "/", notice: "Charge failed: #{failure_message}" 
       notice = "Charge failed: #{failure_message}"
       Rails.logger.info notice
       if flash[:error] == "Your card was declined."
        flash[:notice] = "Try again with a new card!"
       end
       flash[:error] = "Error: #{flash[:error]}"

       respond_to do |format|
         format.html { redirect_to "/", notice: notice }
         format.json { render json: {:status => "failure", :status_message => notice}, status: 400 }
       end
       # format.html { redirect_to @charity, notice: 'Charity was successfully updated.' }
       #  format.json { render :show, status: :ok, location: @charity }
    end
  
# rescue error => e
#   Rails.logger.info("Error: #{e.message}")
# end
end

private
  
  def secure_params
    params.require(:donor_charge).permit(:donation_amount,
    :payment_reference, :charity_id, :revenue, :customer_id, :user_id)
  end


end
