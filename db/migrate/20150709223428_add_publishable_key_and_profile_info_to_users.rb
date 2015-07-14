class AddPublishableKeyAndProfileInfoToUsers < ActiveRecord::Migration
 def change
      add_column :users, :publishable_key, :string
      add_column :users, :provider, :string
      add_column :users, :uid, :string
      add_column :users, :access_code, :string
      add_column :users, :public_profile, :boolean
      add_column :users, :donation_rate, :integer
      add_column :users, :name, :string
      add_column :users, :website, :string
      add_column :users, :description, :string
      add_column :users, :business_name, :string
    end
end