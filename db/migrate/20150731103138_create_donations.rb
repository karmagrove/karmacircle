class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.string :payment_reference
      t.references :charity, index: true, foreign_key: true
      t.integer :donation_amount
      t.integer :status
      t.references :donor, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
