class CreateDonationCharges < ActiveRecord::Migration
  def change
    create_table :donation_charges do |t|
      t.string :payment_reference
      t.references :charity, index: true, foreign_key: true
      t.integer :donation_amount
      t.integer :revenue
      t.integer :status
      t.references :donation, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
