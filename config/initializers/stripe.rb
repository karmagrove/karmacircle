Rails.configuration.stripe = {
  :publishable_key => ENV['PUBLISHABLE_KEY'],
  :secret_key      => ENV['SECRET_KEY'],
  :connect_key => ENV['STRIPE_CONNECT_CLIENT_ID']
}

Stripe.api_key = Rails.configuration.stripe[:connect_key]