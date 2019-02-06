class AddUpSellAndDownSell < ActiveRecord::Migration
  def change
  	add_column :products, :upsell, :integer
  	add_column :products, :downsell, :integer
  end
end
