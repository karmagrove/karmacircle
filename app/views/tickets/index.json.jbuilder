json.array!(@tickets) do |ticket|
  json.extract! ticket, :id, :event_id, :ticket_name, :quantity_available, :price, :description, :sales_start, :sales_end, :ticket_minimum, :ticket_maximum
  json.url ticket_url(ticket, format: :json)
end
