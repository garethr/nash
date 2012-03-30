Screen scraping nagios dashboard that just shows checks in Critical, Warning and OK. Designed for big screens.

Mainly designed for easy running on Heroku, but it's just a small Sinatra application. For configuration set three environment variables:

    NAGIOS_HOST
    AUTH_USERNAME
    AUTH_PASSWORD

## Running locally

First install the dependencies with bundler:

    bundle install

Then run the application:

    NAGIOS_HOST=x AUTH_USERNAME=y AUTH_PASSWORD=z bundle exec ruby app.rb

This should bring up a local web server on localhost:4567. Note that the
username and password are those used to access your Nagios install, as
well as used again to access the running dashboard.
