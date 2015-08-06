class Donation < ActiveRecord::Base
  belongs_to :charity
  belongs_to :donor
  has_many :donation_charges

  def makePayments
  	DonationCharges.where(:status => "unpaid").sort_by(:user_id)
  end
end
