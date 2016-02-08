class AddRequireNameandGenderToProduct < ActiveRecord::Migration
  def change
  	add_column :products, :require_name, :boolean
  	add_column :products, :require_gender, :boolean
  end
end
