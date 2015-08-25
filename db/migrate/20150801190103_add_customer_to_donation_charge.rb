class AddCustomerToDonationCharge < ActiveRecord::Migration
  def change
  	add_column :donation_charges, :customer_id, :string
  end
end
