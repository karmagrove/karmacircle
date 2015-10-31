class Ticket < ActiveRecord::Base
  belongs_to :event
  has_many :ticket_purchases
end
