class AddDonationChargeToTicketPurchases < ActiveRecord::Migration
  def change
  	 add_reference :ticket_purchases, :purchases, index: true, foreign_key: true
  	 add_column :ticket_purchases, :status, :integer
  end
end
