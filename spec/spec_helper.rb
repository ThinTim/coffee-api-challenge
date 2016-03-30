require 'rack/test'
require 'json'
require 'rspec'
require 'sequel'
Sequel.extension :migration

ENV['RACK_ENV'] = 'test'

require_relative '../db'

module RackMixin
  include Rack::Test::Methods

  def post_json(uri, hash)
    post(uri, JSON.generate(hash), { "CONTENT_TYPE" => "application/json" })
  end

  def app()
    Rack::Builder.new do
      eval File.read(File.expand_path("../config.ru", __dir__))
    end
  end
end

RSpec.configure do |c|
  c.include RackMixin

  c.color = true

  c.around(:each) do |example|
    DB.transaction(:rollback=>:always, :auto_savepoint=>true) { example.run }
  end
end
