## THIS NEEDS TO BE CLEANED UP!

class Donation < ActiveRecord::Base
  belongs_to :charity
  belongs_to :user
  has_many :donation_charges

  enum status: [:unpaid, :denied,:payment_sent, :payment_confirmed]
  
  # Donation.transfer({customer: customer, charity: charity, amount: amount})
  def self.transfer(params)
    Stripe.api_key = ENV['STRIPE_API_KEY']
    charity   ||= params[:charity]
    customer  ||= params[:customer]
    amount    ||= params[:amount]
    reference ||= params[:reference]

    params = {
         :amount => amount, # amount in cents
         :currency => "usd",
         :destination => charity.stripe_id
    }

    if reference and reference.length > 0
      Rails.logger.info("source_transaction")
      params[:source_transaction] = reference
      Rails.logger.info(params.inspect)
      # ch_70tTXntmoX1FAu
    end
    success = false
    begin
      success = true
     #  @transfer = Stripe::Transfer.create(
     #    :amount => params[:amount],
     #    :currency => 'usd',
     #    :destination => ""
     # )
      #{CONNECTED_STRIPE_ACCOUNT_ID}

      @transfer = Stripe::Transfer.create(params)
      Rails.logger.info(@transfer)
      
    rescue Exception => e
       success = false
       Rails.logger.info("payment error:")
       Rails.logger.info(e.inspect)
    end

    if success == true
      if customer.email && charity.email 
        donation = Donation.create(
          :charity_id => charity.id, :user_id => customer.id, 
          :donation_amount => amount, :payment_reference => @transfer.id)
        donation.save
        UserMailer.send_donation_receipt(charity, customer, donation).deliver
      end      
      ## update_donation_charges
    end
 
  end


  def self.return_user_unpaid
    new_amount = {}
    new_amount[:total_amount] = 0
    User.all.each do |user|
      Stripe.api_key = user.access_code
      charges = DonationCharge.where(:status => "unpaid", :user_id => user.id).each do |charge|
        puts "charge insepct"
        puts charge.inspect
        begin
        s  = Stripe::Charge.retrieve charge.payment_reference
          if s.status == "succeeded"
            stripe_status = "success"
          end
        rescue Stripe::InvalidRequestError => error
          stripe_status = "failure"
        end


        if charge.donation_amount and stripe_status == "success"
          #new_amount["charity_"+charge["charity_id"].to_s] ||= 0
          new_amount[user.id] ||= { charge["charity_id"] => 0 }
          new_amount[user.id][charge["charity_id"]] ||=0
          #key= "charge_count"+charge["charity_id"].to_s
          #new_amount[key] ||=0
          puts "new_amount"
          puts new_amount.inspect
          #new_amount[key] += 1
          new_amount[:total_amount] += charge.donation_amount 
          new_amount[user.id][charge["charity_id"]] = new_amount[user.id][charge["charity_id"]] + charge.donation_amount 
          #amount["charity_"+charge["charity_id"].to_s] = amount["charity_"+charge["charity_id"].to_s] + charge.donation_amount 
        end
      end
    end
    return new_amount
#(:status => "unpaid", :user_id => user.id).each
  end

  def update_donation_charge_status(charges = {})
     # donation_id = 8
     # donation_id = 10
     # customer = Customer.find x
     donation_id = 33
     # charges = DonationCharge.where(:status => "unpaid", :user_id => customer.id)
     charges = DonationCharge.where(:status => "unpaid", :user_id => customer.id, :charity_id => charity.id)
     charges.each do |charge|
     # charge.charity_id = 26
     charge.update_attribute(:donation_id, donation_id)
    
     charge.update_attribute(:status,"paid")
     charge.save
     end
  end

  def self.makePayments
    # charges.each do |charge|
    # charge.update_attribute(:donation_id, 4)
    
    # charge.update_attribute(:status,"paid")
    # charge.save
    # end
    
    amount = {}

  	User.all.each do |user|
      Stripe.api_key = user.access_code
  	  charges = DonationCharge.where(:status => "unpaid", :user_id => user.id).each do |charge|
        puts "charge insepct"
        puts charge.inspect
        s  = Stripe::Charge.retrieve charge.payment_reference
        puts s.inspect
        if charge.donation_amount and s.status == "succeeded"
          amount[charge["charity_id"]] ||= 0
          amount[user.id] ||= { charge["charity_id"] => 0 }
          #amount[user.id] ||=0
          amount[user.id][charge["charity_id"]] ||= 0
          #amount[user.id][charge["charity_id"]] ||=0
          key = "charge_count"+charge["charity_id"].to_s
          amount[key] ||=0
          puts "amount"
          puts amount.inspect

          amount[key] +=1
            amount[user.id][charge["charity_id"]] = amount[user.id][charge["charity_id"]] + charge.donation_amount 
            amount[charge["charity_id"]] = amount[charge["charity_id"]] + charge.donation_amount 
        end
  	  end
      puts "amount:"
      puts amount.inspect

  	  #customer = Stripe::Customer.find(user.uid)
      p charges
      amount.keys.each do |key|
  	    if amount[key] > 500 then
          p "over 500"

          transfer = Stripe::Transfer.create(
            :amount => 1000, # amount in cents
            :currency => "usd",
            :recipient => recipient_id,
            :bank_account => bank_account_id,
            :statement_descriptor => "JULY SALES"
          )
 
           @donation = Donation.create!(:payment_reference => charge.id ,:donation_amount => charge.amount, :status => :payment_sent, :user_id => user.id)
          charges.
          
           charges.each do |c|
             c.status=:paid
             c.donation_id = @donation.id
             c.save
  	       end
        end
      end
    end
  end
end
