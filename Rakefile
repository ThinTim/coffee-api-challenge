require 'pacto/rake_task'
require 'rspec/core/rake_task'

task :default => :spec
RSpec::Core::RakeTask.new(:spec) do
  #Run migration before starting tests
  Rake::Task["db:migrate"].invoke
end

desc 'Start a local development server on the default port'
task 'start' do
  `rackup -p 4567`
end

desc 'Run pacto validations against the default local development url'
task 'validate' do
  Rake::Task["pacto:validate"].invoke('http://localhost:4567', 'contracts')
end

namespace :db do
  require "sequel"
  Sequel.extension :migration

  directory 'db'

  desc "Migrate dev & test databases to latest version"
  task :migrate => ['db'] do
    %w(development test).each do |env|
      db = Sequel.sqlite("./db/#{env}.db")
      Sequel::Migrator.run(db, "migrations")
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
end
