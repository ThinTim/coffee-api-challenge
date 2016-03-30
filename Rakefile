require 'pacto/rake_task'
require 'rspec/core/rake_task'

ENV['RACK_ENV'] ||= 'development'

task :default => :spec

#Hidden with empty description to prevent running tests in non-test environments
desc ''
RSpec::Core::RakeTask.new(:rspec)

desc 'Run rspec tests'
task 'spec' do
  system 'RACK_ENV=test rake db:reset'
  sleep 1 #Sometimes the migrations don't finish before the specs run
  system 'RACK_ENV=test rake rspec'
end

desc 'Start a local server on the default port'
task 'start' => ['db:migrate'] do
  system 'rackup -p 4567'
end

desc 'Run pacto validations against the default local port'
task 'validate' => ['db:seed'] do
  Rake::Task['pacto:validate'].invoke('http://localhost:4567', 'contracts')
end

namespace :db do
  require_relative './db'
  require "sequel"
  Sequel.extension :migration

  directory 'db'

  desc "Migrate current database to the latest version"
  task :migrate => ['db'] do
    Sequel::Migrator.run(DB, 'migrations')
  end

  desc 'Reset the current database'
  task :reset => ['db'] do
    raise Error.new('Cannot reset production database!') if ENV['RACK_ENV'] == 'production'

    Sequel::Migrator.run(DB, 'migrations', target: 0)
    Sequel::Migrator.run(DB, 'migrations')
  end

  desc 'Seed current database with data that meets the pacto contracts'
  task :seed => ['db:reset'] do
    DB[:coffees].insert(id: 'long-black', name: "long black", price: 3, caffeine_level: 8, milk_ratio: 0, brewing_time: 30)
    DB[:coffees].insert(id: 'flat-white', name: "flat white", price: 3.5, caffeine_level: 5, milk_ratio: 2, brewing_time: 30)
    DB[:coffees].insert(id: 'latte', name: "latte", price: 3.5, caffeine_level: 5, milk_ratio: 3, brewing_time: 30)
    DB[:coffees].insert(id: 'espresso', name: "espresso", price: 2, caffeine_level: 10, milk_ratio: 0, brewing_time: 30)
    DB[:coffees].insert(id: 'machiato', name: "machiato", price: 2.5, caffeine_level: 10, milk_ratio: 0.5, brewing_time: 30)

    DB[:orders].insert(id: 123, coffee_id: 'long-black', extras_list: '[]', size: 'small', pickup_time: Time.now - 10)
  end
end
