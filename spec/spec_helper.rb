require 'rack/test'
require 'rspec'
require 'sequel'
Sequel.extension :migration

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

  c.before(:all) do
    Sequel::Migrator.run(DB, 'migrations', target: 0)
    Sequel::Migrator.run(DB, 'migrations')
  end

  c.around(:each) do |example|
    DB.transaction(:rollback=>:always, :auto_savepoint=>true) { example.run }
  end
end
