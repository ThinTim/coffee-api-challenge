require 'sinatra/base'
require 'sinatra/contrib'
require 'sequel'
require_relative '../models/coffee'

module Routes
  module Menu
    def coffee_as_menu_item(coffee)
      {
        name: coffee.name,
        order_path: "/order/#{coffee.id}",
        price: coffee.price,
        caffeine_level: coffee.caffeine_level,
        milk_ratio: coffee.milk_ratio,
      }
    end

    def self.registered(app)
      app.helpers self

      app.get '/menu' do
        json(coffees: Models::Coffee.all.map { |c| coffee_as_menu_item(c) })
      end
    end
  end
end
