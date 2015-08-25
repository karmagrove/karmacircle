class DonationCharge < ActiveRecord::Base
  belongs_to :charity
  belongs_to :donation
  belongs_to :donor
  belongs_to :user
  enum status: [:unpaid, :denied, :paid]
  
  after_initialize :set_default_status, :if => :new_record?
  

  def set_default_status
  	self.status || :unpaid
  end
end
