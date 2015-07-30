class AddTransactionCostToUser < ActiveRecord::Migration
  def change
  	add_column :users, :transaction_cost, :integer
  end
end
