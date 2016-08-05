class AddPassOnFeesAndMatchDonationToUser < ActiveRecord::Migration
  def change
  	add_column :users, :customer_pay_fees, :integer
  	add_column :users, :allow_customer_match_donation, :boolean
  end
end
