class AddBuyerEmailToPurchase < ActiveRecord::Migration
 def change
  	add_column :purchases, :buyer_name, :string
  end
end
