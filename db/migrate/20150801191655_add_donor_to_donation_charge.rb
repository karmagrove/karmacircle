class AddDonorToDonationCharge < ActiveRecord::Migration
  def change
  	 add_reference :donation_charges, :user, index: true, foreign_key: true
  end
end
