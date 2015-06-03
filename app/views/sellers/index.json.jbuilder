json.array!(@sellers) do |seller|
  json.extract! seller, :id, :name, :description, :url, :stripe_id, :email, :city, :state, :password
  json.url seller_url(seller, format: :json)
end
