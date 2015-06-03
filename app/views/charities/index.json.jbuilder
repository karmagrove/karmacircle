json.array!(@charities) do |charity|
  json.extract! charity, :id, :name, :description, :url, :stripe_id, :email, :city, :state
  json.url charity_url(charity, format: :json)
end
