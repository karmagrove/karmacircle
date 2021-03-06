class PurchasesController < ApplicationController
  protect_from_forgery with: :null_session

def success

end


def send_invoice
  email = params[:email]
  UserMailer.send_invoice(email).deliver
end

def create
  # Amount in cents
  #@amount = (params[:amount].to_f * 100).to_i
  failure_message = ""
  if current_user 
    seller = current_user
  else
    seller = User.find(params[:user_id])
  end
  @amount = params[:amount]
  @allow_matching = params[:allowMatching]
  Rails.logger.info("@amount:#{@amount}, allowMatching #{@allow_matching}")

  if Stripe.api_key = seller.access_code

  else
    Stripe.api_key = ENV['STRIPE_API_KEY']
  end

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
  Rails.logger.info "seller.email #{seller.email} and customer #{customer.inspect}"
  Rails.logger.info "params #{params.inspect}"
  product_id = params[:product_id].to_i

  ## seller.calculate_application_fee
  application_fee = seller.transaction_cost
  @product = Product.find(product_id)
  donation_rate = @product.donation_percent
  donation_rate ||= seller.donation_rate
  donation_amount = (@amount.to_i*donation_rate/100).to_i
  Rails.logger.info("seller.donation_rate: #{seller.donation_rate}")
  Rails.logger.info("donation_amount #{donation_amount}")
  if params[:allowMatching] == "true"
    Rails.logger.info ("matching true donation now is #{donation_amount}")
    donation_amount = donation_amount * 2
    Rails.logger.info ("matching true donation now  after * 2 is #{donation_amount}")
  end
  application_fee = application_fee + donation_amount
  Rails.logger.info("application_fee #{application_fee}")
      Rails.logger.info("donation_amount #{donation_amount.to_s}")
    Rails.logger.info("application_fee #{application_fee.to_s}")
    #application_fee = application_fee + donation_amount
    Rails.logger.info("application_fee + donation_amount: #{application_fee.to_s}")

  currency = "usd"
  if seller.currency
    currency = seller.currency 
  end
  
  
  unless product_id == 0 
    @product = Product.find(product_id)
    if @product.currency 
      currency = @product.currency 
    end
  end
  
  

  if (seller.email == "joshua@karmagrove.com") or (seller.email == "joshua.montross@gmail.com") then
    begin
      charge = Stripe::Charge.create({
    :amount => @amount, # amount in cents
    :currency => currency,
    :customer => customer,
    :description => description
  },
  {:stripe_account => seller.uid}
  )

      rescue Stripe::AuthenticationError => e
      Rails.logger.info("Error in card reader: #{e.message}")
      flash[:error] = e.message
      #flash[:notice] = "The card is not working: #{e.message}"
      #redirect_to charges_path, :notice => "The card is not working: #{e.message}"
       failure_message = e.message
       status = "failure"
       Rails.logger.info "first error"
     

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
    #donation_amount = (@amount.to_i*seller.donation_rate/100).to_i

    Rails.logger.info("donation_amount #{donation_amount.to_s}")
    Rails.logger.info("application_fee #{application_fee.to_s}")

    application_fee = application_fee + donation_amount
    Rails.logger.info("application_fee + donation_amount: #{application_fee.to_s}")
    ## to make the donations come out with the application fee. 
    begin 
      charge = Stripe::Charge.create({
       :amount => @amount, # amount in cents
       :currency => currency,
       :customer => customer,
       :description => description,
       :application_fee => application_fee, # amount in cents
       },
       {:stripe_account => seller.uid}
      )

    rescue Stripe::AuthenticationError => e
      Rails.logger.info("Error in card reader: #{e.message}")
      flash[:error] = e.message
      #flash[:notice] = "The card is not working: #{e.message}"
      #redirect_to charges_path, :notice => "The card is not working: #{e.message}"
       failure_message = e.message
       status = "failure"
       Rails.logger.info "first error"


     rescue Stripe::CardError => e
      Rails.logger.info("Error in card reader: #{e.message}")
      flash[:error] = e.message
      #flash[:notice] = "The card is not working: #{e.message}"
      #redirect_to charges_path, :notice => "The card is not working: #{e.message}"
       failure_message = e.message
       status = "failure"
       Rails.logger.info "first error"
      end
  end

  if charge and charge.status == "succeeded"

    Rails.logger.info "charge.inspect"
    Rails.logger.info charge.inspect
    #donation_amount = (charge.amount*(seller.donation_rate/100.to_f)).to_i
    donation_amount = donation_amount.to_i
    Rails.logger.info("donation_amount: #{donation_amount}")

    if params[:charity_id]
      charity_id = params[:charity_id]
    else 
      if seller.charity_users
        charity_id = seller.charity_users.first.charity_id
      else
        charity_id = 4
      end
    end
    # Donation.where
  
    @donorCharge = DonationCharge.new(donation_amount: donation_amount, 
      payment_reference: charge.id, charity_id: charity_id, 
      revenue: charge.amount, customer_id: customer.id, 
      user_id:seller.id)
    Rails.logger.info "donorcharge.inspect"
    Rails.logger.info @donorCharge.inspect
    @user = seller
    if @donorCharge.save(:status => "pending")
      customer= {}
    	begin 
        @purchase = Purchase.new(:buyer_email => params[:stripeEmail])
        @purchase.donation_charge_id = @donorCharge.id
        Rails.logger.info("params inspect #{params.inspect}")
        if params[:product_id] and params[:product_id].to_i != 0
          Rails.logger.info("params product_id #{params[:product_id]}")
          @purchase.product_id = params[:product_id].to_i
          @product = Product.find(@purchase.product_id)
          Rails.logger.info("params product_id #{params[:product_id]} and product #{@product.inspect}")
          customer= {}
          if @product.require_name and params[:customer_name]
            customer[:name] = params[:customer_name]
            @purchase.buyer_name = params[:customer_name]
          end
          if @product.require_gender and params[:customer_gender]
            customer[:gender] = params[:customer_gender]
          end
          if @product.special_instructions and params[:special_instructions]
            customer[:special_instructions] = params[:special_instructions]
            Rails.logger.info("special_instructions")
          end
        end
        @purchase.save
        @purchase.delay.update_pike13_with_purchase
        UserMailer.delay.send_receipt(params[:stripeEmail],@donorCharge)
        customer[:stripeEmail] = params[:stripeEmail]
        UserMailer.delay.send_receipt_copy(customer,@donorCharge)
        @notice = 'Charge succeeded: check your email'
      rescue Exception => e
        Rails.logger.info("Exception: #{e.message}")
      end
      
      # if seller.email == "uptown@thecryozone.com" 
      #   redirect_to "http://www.thecryozone.com/locations/uptown-dallas" and return 
      # else
      # redirect_to "/",  notice: @notice
      # end  
      if @product.quantity and @product.quantity > 0 
        @product.quantity = @product.quantity - 1
        @product.save
      end

      respond_to do |format|
        format.html { redirect_to "/", notice: 'Charge made'}
        format.json { render json:  {:status => "success"}, status: 200 }
      end
    else
      respond_to do |format|
       format.html { redirect_to "/", notice: 'Charge failed: #{charge.failure_message}' }
       format.json { render json: @user.errors, status: :unprocessable_entity }
      end

     end

  else
    Rails.logger.info "no awesome charge"
    notice = "Charge failed: #{failure_message}"
    respond_to do |format|
      format.html { redirect_to "/", notice: 'Charge failed: #{charge.failure_message}' }
      format.json { render json: {:status => "failure", :status_message => notice}, status: 400 }
  end
  end

end

private
  
  def secure_params
    params.require(:donor_charge).permit(:donation_amount,
    :payment_reference, :charity_id, :revenue, :customer_id, :user_id, :special_instructions, :allowMatching)
  end


end
