require 'sinatra/base'
require 'sinatra/contrib'
require 'sequel'

module Routes
  module Errors
    def self.registered(app)
      app.set :show_exceptions, :after_handler

      app.not_found do
        status 404
        json message: 'The requested route does not exist'
      end

      app.error Sequel::NoMatchingRow do
        status 404
        json message: 'The requested resource does not exist'
      end

      app.error Sequel::ValidationFailed do |err|
        status 400
        json message: 'The request was invalid', errors: err.errors.full_messages
      end

      app.error do
        status 500
        json message: 'An unexpected error occurred'
      end
    end
  end
end
