class Donor < User
  has_many :donations
  has_many :donation_charges
end