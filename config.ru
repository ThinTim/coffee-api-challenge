require 'rack/parser'
require 'json'

ENV['RACK_ENV'] ||= 'development'

require './db'
require './app'

use Rack::Parser, :content_types => {
  'application/json' => proc { |data| JSON.parse data }
}

run App
