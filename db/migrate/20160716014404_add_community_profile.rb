class AddCommunityProfile < ActiveRecord::Migration
  def change
  	 add_column :users, :community_profile, :boolean 
  end
end
