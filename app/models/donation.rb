class Donation < ActiveRecord::Base
  belongs_to :charity
  belongs_to :donor
  has_many :donation_charges
end
