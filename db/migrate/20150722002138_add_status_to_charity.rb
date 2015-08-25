class AddStatusToCharity < ActiveRecord::Migration
  def change
  	add_column :charities, :status, :integer
  end
end