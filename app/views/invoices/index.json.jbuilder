json.array!(@invoices) do |invoice|
  json.extract! invoice, :id, :user_id, :recipient_email, :status, :donation_charge_id, :amount, :secret, :description, :stripe_customer_id
  json.url invoice_url(invoice, format: :json)
end
