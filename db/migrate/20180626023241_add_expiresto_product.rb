class AddExpirestoProduct < ActiveRecord::Migration
  def change
  	 add_column :products, :expires_at, :datetime
  end
end
