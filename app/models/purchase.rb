class Purchase < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
  belongs_to :donation_charge
  has_many :ticket_purchases
end
