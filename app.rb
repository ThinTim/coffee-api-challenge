require 'sinatra/base'
require 'sinatra/json'
require 'json'
require_relative 'routes/errors'
require_relative 'routes/menu'
require_relative 'routes/order'

class App < Sinatra::Base
  register Routes::Errors
  register Routes::Menu
  register Routes::Order
end
