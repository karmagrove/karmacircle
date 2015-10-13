json.array!(@products) do |product|
  json.extract! product, :id, :description, :name, :price, :public, :donation_percent, :image_url, :user_id
  json.url product_url(product, format: :json)
end
