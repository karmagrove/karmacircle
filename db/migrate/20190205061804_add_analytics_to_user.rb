class AddAnalyticsToUser < ActiveRecord::Migration
  def change
  	add_column :users, :facebookpixel, :integer
  	add_column :users, :googleanalytics, :string
  end
end
