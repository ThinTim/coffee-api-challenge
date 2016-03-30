require 'rack/parser'
require 'json'

require './db'
require './app'

use Rack::Parser, :content_types => {
  'application/json' => proc { |data| JSON.parse data }
}

run App
