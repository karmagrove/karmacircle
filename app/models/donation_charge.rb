class DonationCharge < ActiveRecord::Base
  belongs_to :charity
  belongs_to :donation
end
