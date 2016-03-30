require 'pacto/rake_task'
require 'rspec/core/rake_task'

task :default => :spec
RSpec::Core::RakeTask.new(:spec) do
  #Run migration before starting tests
  Rake::Task['db:migrate'].invoke
end

desc 'Start a local development server on the default port'
task 'start' do
  `rackup -p 4567`
end

desc 'Run pacto validations against the default local development url'
task 'validate' do
  Rake::Task['pacto:validate'].invoke('http://localhost:4567', 'contracts')
end

namespace :db do
  require "sequel"
  Sequel.extension :migration

  directory 'db'

  desc "Migrate dev & test databases to latest version"
  task :migrate => ['db'] do
    %w(development test).each do |env|
      db = Sequel.sqlite("./db/#{env}.db")
      Sequel::Migrator.run(db, 'migrations')
    end
  end

  desc 'Reset dev & test databases'
  task :reset => ['db'] do
    %w(development test).each do |env|
      db = Sequel.sqlite("./db/#{env}.db")
      Sequel::Migrator.run(db, 'migrations', target: 0)
      Sequel::Migrator.run(db, 'migrations')
    end
  end

  desc 'Seed the dev database with data that meets the pacto contracts'
  task :seed => ['db:reset'] do
    db = Sequel.sqlite('./db/development.db')

    db[:coffees].insert(id: 'long-black', name: "long black", price: 3, caffeine_level: 8, milk_ratio: 0, brewing_time: 30)
    db[:coffees].insert(id: 'flat-white', name: "flat white", price: 3.5, caffeine_level: 5, milk_ratio: 2, brewing_time: 30)
    db[:coffees].insert(id: 'latte', name: "latte", price: 3.5, caffeine_level: 5, milk_ratio: 3, brewing_time: 30)
    db[:coffees].insert(id: 'espresso', name: "espresso", price: 2, caffeine_level: 10, milk_ratio: 0, brewing_time: 30)
    db[:coffees].insert(id: 'machiato', name: "machiato", price: 2.5, caffeine_level: 10, milk_ratio: 0.5, brewing_time: 30)

    db[:orders].insert(id: 123, coffee_id: 'long-black', extras_list: '[]', size: 'small', pickup_time: Time.now - 10)
  end
end
