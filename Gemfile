source 'https://rubygems.org'
ruby '2.1.3'

gem 'dotenv-rails', :groups => [:development, :test]
gem 'rails', '4.2.1'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
gem 'omniauth-stripe-connect'
gem 'turbolinks'
gem 'omniauth-facebook'
gem 'faraday','~> 0.8.6'
gem "koala", "~> 1.7.0rc1"
# https://github.com/whomwah/rqrcode
gem 'rqrcode'

group :development, :test do
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'sqlite3'
  gem "letter_opener"
end


gem 'foundation-rails', '~> 5.5'
gem 'carrierwave', '~>0.11.2'
gem 'fog-aws'
# gem 'fog'  ## only needed for non aws installs.  fog-aws is slimmer for AWS only as we are using
gem 'mini_magick'
gem 'compass-rails', github: "Compass/compass-rails", branch: "master"
gem 'font-awesome-rails'
gem 'devise',           '~> 3.5.2'
gem 'devise_invitable', '~> 1.6.0'
gem 'gibbon'
gem 'payola-payments'
gem 'sendgrid'
gem 'sucker_punch'
gem 'delayed_job_active_record'

group :production do
  gem 'pg'
  gem 'rails_12factor'

end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
end