require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

require_relative '../db.rb'
require_relative '../app.rb'

module RackMixin
  include Rack::Test::Methods
  def app() App end
end

RSpec.configure do |c|
  c.include RackMixin

  c.color = true

  c.around(:each) do |example|
    DB.transaction(:rollback=>:always, :auto_savepoint=>true) { example.run }
  end
end
