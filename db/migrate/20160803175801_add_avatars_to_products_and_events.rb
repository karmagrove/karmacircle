class AddAvatarsToProductsAndEvents < ActiveRecord::Migration
  def change
    add_column :products, :avatars, :string
    add_column :products, :avatar, :string
    add_column :events, :avatars, :string
    add_column :events, :avatar, :string
  end
end
