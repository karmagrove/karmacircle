class UserMailer < ActionMailer::Base
  default :from => "do-not-reply@karmagrove.com"

  def expire_email(user)
    mail(:to => user.email, :subject => "Subscription Cancelled")
  end

  def send_receipt(customer, donationCharge)
  	@customer = customer
  	@donationCharge = donationCharge
  	mail(:to => customer, :subject => "Thank you for your purchase")
  end

  def send_receipt_copy(customer, donationCharge)
  	@customer = customer
  	@donationCharge = donationCharge
  	mail(:to => @donationCharge.user.email, :subject => "SENT TO CUSTOMER: Thank you for your purchase")
  end


  def send_donation_receipt(charity, customer, donation)
    @customer = customer
    @donation = donation
    @charity = charity
    mail(:to => [customer.email,charity.email], :subject => "#{customer.email} has donated $#{sprintf("%03d", @donation.donation_amount).insert(-3, ".")} to #{charity.name} via Karma Grove ")
  end

end
