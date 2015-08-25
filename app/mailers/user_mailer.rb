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
end
