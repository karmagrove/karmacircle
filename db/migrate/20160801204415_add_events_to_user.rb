class AddEventsToUser < ActiveRecord::Migration

  def change
  	add_column :users, :events_allowed, :boolean
  end

end
