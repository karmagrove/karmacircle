class Donation < ActiveRecord::Base
  belongs_to :charity
  belongs_to :donor
  has_many :donation_charges

  enum status: [:unpaid, :denied,:payment_sent, :payment_confirmed]

  def self.makePayments
    amount = {}
  	User.all.each do |user|
  	  charges = DonationCharge.where(:status => "unpaid", :user_id => user.id).each do |charge|
        puts "charge insepct"
        puts charge.inspect
        if charge.donation_amount
          amount[charge["charity_id"]] ||= 0
          puts "amount"
          puts amount.inspect
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
