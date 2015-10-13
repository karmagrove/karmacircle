class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.string :address
      t.string :city
      t.integer :zip_code
      t.string :state
      t.datetime :end_time
      t.datetime :start_time
      t.boolean :published
      t.integer :total_donated
      t.integer :total_sales
      t.integer :revenue_donation_percent
      t.integer :status
      t.string :event_image_url
      t.references :user, index: true, foreign_key: true
      t.string :organizer_name
      t.string :organizer_description

      t.timestamps null: false
    end
  end
end
