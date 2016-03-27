require 'sinatra/base'
require 'sinatra/json'
require 'json'

require_relative 'routes/errors'

class App < Sinatra::Base

  register Routes::Errors

  get '/' do
    json 'Hello world!'
  end
end
