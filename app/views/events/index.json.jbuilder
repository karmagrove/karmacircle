json.array!(@events) do |event|
  json.extract! event, :id, :name, :description, :address, :city, :zip_code, :state, :end_time, :start_time, :published, :total_donated, :total_sales, :revenue_donation_percent, :status, :event_image_url, :user_id, :organizer_name, :organizer_description
  json.url event_url(event, format: :json)
end
