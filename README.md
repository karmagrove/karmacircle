karmacircle
===========

The website supporting circle app.  Uses stripe to process payments and pay charities.  Allows charities to sign up.  Roles of Customer(seller), Charity, and Buyers(customer's customer).  This is a marketplace app.  It is to have APIs to support the circle app for iOS one day....  

https://stripe.com/docs/connect/payments-fees#collecting-fees

https://dashboard.stripe.com/account/transfers

https://stripe.com/docs/connect/payments-fees#charging-through-the-platform

How to run app
===========
bundle install && rake db:migrate && rake db:seed

=======
KarmaGrove.com Circle Payments - Conscious Commerce System for selling, sending invoices and giving as you receive.
================

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

This application was generated with the [rails_apps_composer](https://github.com/RailsApps/rails_apps_composer) gem
provided by the [RailsApps Project](http://railsapps.github.io/).

Rails Composer is open source and supported by subscribers. Please join RailsApps to support development of Rails Composer.

Ruby on Rails
-------------

This application requires:

- Ruby 2.1.3
- Rails 4.2.1

Learn more about [Installing Rails](http://railsapps.github.io/installing-rails.html).

Getting Started
---------------

Documentation and Support
-------------------------

Issues
-------------

Similar Projects
----------------

Contributing
------------

Credits
-------

Todo
-------
## Make it so people can create customers without having stripe account.  
## Make it so automatically it goes to stripe when people sign up
## make it so the site is as professional looking as paypal.
## Remove credit card requirement for plans that don't need them
## add automatic redirect to stripe after login.... after 5 seconds... and tell them they will be redirected.

License
-------
Don't steal this. Creative Commons.