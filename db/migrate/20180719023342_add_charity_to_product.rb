class AddCharityToProduct < ActiveRecord::Migration
  def change
  	 add_reference :products, :charity, index: true, foreign_key: true
  	 # add_column :products, :charity, :references
  end
end
