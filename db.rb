require 'sequel'
require 'sqlite3'

DB = Sequel.sqlite("./db/#{ENV['RACK_ENV']}.db")
