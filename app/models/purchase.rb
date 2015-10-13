class Purchase < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
  belongs_to :donationcharge
end
