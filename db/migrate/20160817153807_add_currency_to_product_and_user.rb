class AddCurrencyToProductAndUser < ActiveRecord::Migration
  def change
  	add_column :users, :currency, :integer
  	add_column :products, :currency, :integer
  end
end
