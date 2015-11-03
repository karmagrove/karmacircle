class TicketPurchase < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :user
  belongs_to :purchases
  belongs_to :event
  #has_many :donation_charges 
  
  enum status: [:purchased, :redeemed]

  def send_ticket
  	@ticket_purchase = self
  	@event = @ticket_purchase.ticket.event
  	@url = "https://www.karmagrove.com/events/#{@event.id}/tickets/#{@ticket_purchase.ticket.id}/ticket_purchases/#{@ticket_purchase.id}?redeem=true"
  	 if @ticket_purchase.buyer_email and @event and @url
  	   UserMailer.send_event_ticket(@ticket_purchase.buyer_email,@event, @url).deliver
  	 end
  end
end
