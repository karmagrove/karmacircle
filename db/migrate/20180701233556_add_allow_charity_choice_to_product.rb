class AddAllowCharityChoiceToProduct < ActiveRecord::Migration
  def change
  	 add_column :products, :charity_choice, :boolean
  end
end
