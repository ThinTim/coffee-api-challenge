require 'sinatra/base'
require 'sinatra/contrib'
require 'sequel'

module Routes
  module Order
    def self.registered(app)
      app.post '/order/:coffee_id' do

      end

      app.get '/order/:order_id' do

      end
    end
  end
end
