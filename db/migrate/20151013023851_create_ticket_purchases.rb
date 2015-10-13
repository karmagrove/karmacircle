class CreateTicketPurchases < ActiveRecord::Migration
  def change
    create_table :ticket_purchases do |t|
      t.references :ticket, index: true, foreign_key: true
      t.string :payment_reference_url
      t.string :buyer_email
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
