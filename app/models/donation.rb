class Donation < ActiveRecord::Base
  belongs_to :charity
  belongs_to :donor
  has_many :donation_charges

  def makePayments
  	User.all.each do |user|
  	  amount = {}
  	  charges = DonationCharge.where(:status => "unpaid", :donor_id => user.id).each do |charge|
  	  	amount[charge["charity_id"]] ||= amount[charge["charity_id"]] + charge.donation_amount
  	  end

  	  customer = customer = Stripe::Customer.find(user.uid)

  	  if amount > 500 then
  	  	 charge = Stripe::Charge.create({
           :amount => @amount, # amount in cents
           :currency => "usd",
           :customer => customer,
           :description => description
         },
         {:stripe_account => charity.uid}
         )        

  	  end

  end
end
