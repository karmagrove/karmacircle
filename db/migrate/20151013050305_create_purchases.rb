class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.references :product, index: true, foreign_key: true
      t.string :buyer_email
      t.references :user, index: true, foreign_key: true
      t.references :donationcharge, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
