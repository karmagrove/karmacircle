json.array!(@ticket_purchases) do |ticket_purchase|
  json.extract! ticket_purchase, :id, :ticket_id, :payment_reference_url, :buyer_email, :user_id
  json.url ticket_purchase_url(ticket_purchase, format: :json)
end
