class Donation < ActiveRecord::Base
  belongs_to :charity
  belongs_to :user
  has_many :donation_charges

  enum status: [:unpaid, :denied,:payment_sent, :payment_confirmed]
  Donation.transfer({customer: customer, charity: charity, amount: amount})
  def self.transfer(params)
    Stripe.api_key = ENV['STRIPE_API_KEY']
    charity   ||= params[:charity]
    customer  ||= params[:customer]
    amount    ||= params[:amount]
    reference ||= params[:reference]

    params = {
         :amount => amount, # amount in cents
         :currency => "usd",
         :recipient => charity.stripe_id
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

  def self.makePayments
    # charges.each do |charge|
    # charge.update_attribute(:donation_id, 4)
    
    # charge.update_attribute(:status,"paid")
    # charge.save
    # end
    
    amount = {}

  	User.all.each do |user|
  	  charges = DonationCharge.where(:status => "unpaid", :user_id => user.id, :charity_id => 8).each do |charge|
        puts "charge insepct"
        puts charge.inspect
        if charge.donation_amount
          amount[charge["charity_id"]] ||= 0
          key= "charge_count"+charge["charity_id"].to_s
          amount[key] ||=0
          puts "amount"
          puts amount.inspect
          amount[key] +=1
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
