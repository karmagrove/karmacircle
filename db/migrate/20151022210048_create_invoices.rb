class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.references :user, index: true, foreign_key: true
      t.string :recipient_email
      t.string :status
      t.references :donation_charge, index: true, foreign_key: true
      t.integer :amount
      t.string :secret
      t.string :description
      t.string :stripe_customer_id

      t.timestamps null: false
    end
  end
end
