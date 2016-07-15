class PurchasesController < ApplicationController

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
  Rails.logger.info("@amount:#{@amount}")

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

  ## seller.calculate_application_fee
  application_fee = seller.transaction_cost
  donation_amount = (@amount.to_i*seller.donation_rate/100).to_i
  Rails.logger.info("seller.donation_rate: #{seller.donation_rate}")
  Rails.logger.info("donation_amount #{donation_amount}")
  application_fee = application_fee + donation_amount
  Rails.logger.info("application_fee #{application_fee}")
      Rails.logger.info("donation_amount #{donation_amount.to_s}")
    Rails.logger.info("application_fee #{application_fee.to_s}")
    #application_fee = application_fee + donation_amount
    Rails.logger.info("application_fee + donation_amount: #{application_fee.to_s}")
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
    donation_amount = (@amount.to_i*seller.donation_rate/100).to_i

    Rails.logger.info("donation_amount #{donation_amount.to_s}")
    Rails.logger.info("application_fee #{application_fee.to_s}")

    application_fee = application_fee + donation_amount
    Rails.logger.info("application_fee + donation_amount: #{application_fee.to_s}")
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
    donation_amount = (charge.amount*(seller.donation_rate/100.to_f)).to_i
    Rails.logger.info("donation_amount: #{donation_amount}")

    if seller.charity_users
      charity_id = seller.charity_users.first.charity_id
    else
      charity_id = 4
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
        if params[:product_id]
          Rails.logger.info("params product_id #{params[:product_id]}")
          @purchase.product_id = params[:product_id].to_i
          @product = Product.find(@purchase.product_id)
          Rails.logger.info("params product_id #{params[:product_id]} and product #{@product.inspect}")
          customer= {}
          if @product.require_name and params[:customer_name]
            customer[:name] = params[:customer_name]
          end
          if @product.require_gender and params[:customer_gender]
            customer[:gender] = params[:customer_gender]
          end
          if @product.special_instructions and params[:special_instuctions]
            customer[:special_instructions] = params[:special_instructions]
            Rails.logger.info("special_instructions")
          end
        end
        @purchase.save
        
        UserMailer.send_receipt(params[:stripeEmail],@donorCharge).deliver
        customer[:stripeEmail] = params[:stripeEmail]
        UserMailer.send_receipt_copy(customer,@donorCharge).deliver

        @notice = 'Charge succeeded: check your email'
      rescue Exception => e
        Rails.logger.info("Exception: #{e.message}")
      end
  
      redirect_to "/",  notice: @notice
      #format.html { redirect_to "/", notice: 'Charge made'}
      #format.json { render :show, status: :created, location: @user }
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
    :payment_reference, :charity_id, :revenue, :customer_id, :user_id)
  end


end
