class UserMailer < ActionMailer::Base
  default :from => "do-not-reply@karmagrove.com"

  def expire_email(user)
    mail(:to => user.email, :subject => "Subscription Cancelled")
  end

  def send_invoice(email,url)
    @email = email
    @url = url
    mail(:to => email, :subject => "Please complete the invoice and we will give to charity")
  end

  def send_invoice_copy(email,url,sender)
    @email = email
    @url = url
    mail(:to => sender, :subject => "COPY SENT TO #{@email}: Please complete the invoice and we will give to charity")
  end

  def send_receipt(customer, donationCharge)
  	@customer = customer
  	@donationCharge = donationCharge
    @product = nil
    if @donationCharge.purchases and @donationCharge.purchases.first and @donationCharge.purchases.first.product
      @product = @donationCharge.purchases.first.product
    end
  	mail(:to => customer, :subject => "Thank you for your purchase")
  end

  def send_receipt_copy(customer, donationCharge)
    @product = nil
    @donationCharge = donationCharge
    Rails.logger.info "in receipt copy"
    Rails.logger.info customer.inspect
    @customer_email = donationCharge.user.email
    @customer = customer[:stripeEmail]
    
    @customer_name = customer[:name]

    @customer_gender = customer[:gender]

    @special_instructions = customer[:special_instructions]
    
    Rails.logger.info "#{@customer.inspect}, #{@customer_email.inspect}, @special_instructions #{@special_instructions}"
    
      
    
    
    if @donationCharge.purchases and @donationCharge.purchases.first and @donationCharge.purchases.first.product
      @product = @donationCharge.purchases.first.product
    end
  	
  	
  	mail(:to => @donationCharge.user.email, :subject => "SENT TO CUSTOMER #{@customer}: Thank you for your purchase")
  end


  def send_donation_receipt(charity, customer, donation)
    @customer = customer
    @donation = donation
    @charity = charity
    mail(:to => [customer.email,charity.email], :subject => "#{customer.email} has donated $#{sprintf("%03d", @donation.donation_amount).insert(-3, ".")} to #{charity.name} via Karma Grove ")
  end

  def send_event_ticket(customer_email,event,url)
    # @qr = RQRCode::QRCode.new(url, :size => 7, :level => :h )
    @event = event
    @customer_email = customer_email
    @url = url
    if Charity.exists?(@event.user.charity_users.last.charity_id)
      @charity = Charity.find(@event.user.charity_users.last.charity_id)
    else
      @charity = nil
    end
    mail(:to => customer_email, :subject => "Ticket for your upcoming event #{event.name} enclosed")
  end

end
