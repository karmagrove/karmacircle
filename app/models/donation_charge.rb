class DonationCharge < ActiveRecord::Base
  belongs_to :charity
  belongs_to :donation
  belongs_to :donor

  after_initialize :set_default_status, :if => :new_record?
  enum status: [:unpaid, :denied, :paid]

  def set_default_status
  	self.status || :unpaid
  end
end
