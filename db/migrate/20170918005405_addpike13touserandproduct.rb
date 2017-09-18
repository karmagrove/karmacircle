class Addpike13touserandproduct < ActiveRecord::Migration
  def change
  	add_column :users, :pike13subdomain, :string
  	add_column :users, :pike13token, :string
  	add_column :products, :pike13productid, :integer
  end
end
