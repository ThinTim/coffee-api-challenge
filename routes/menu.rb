require 'sinatra/base'
require 'sinatra/contrib'
require 'sequel'

module Routes
  module Menu
    def self.registered(app)
      app.get '/menu' do

      end
    end
  end
end
