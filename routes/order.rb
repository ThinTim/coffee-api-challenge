require 'sinatra/base'
require 'sinatra/contrib'
require 'sequel'
require_relative '../models/order'

module Routes
  module Order
    def self.registered(app)
      app.post '/order/:coffee_id' do
        coffee = Models::Coffee.with_pk!(params['coffee_id'])

        order = Models::Order.new
        order.coffee = coffee
        order.size = params['size']
        order.extras = params['extras']
        order.pickup_time = Time.parse(params['pickup_time']) if params['pickup_time']
        order.save

        status 201
        json(order: "/order/#{order.id}", wait_time: order.pickup_time - Time.now)
      end

      app.get '/order/:order_id' do
        order = Models::Order.with_pk!(params['order_id'])
        json(status: order.status)
      end
    end
  end
end
