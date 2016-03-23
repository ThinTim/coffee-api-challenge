require 'pacto/rake_task'
require 'rspec/core/rake_task'

task :default => :spec
RSpec::Core::RakeTask.new(:spec)

desc 'Start a local development server on the default port'
task 'start' do
  `rackup -p 4567`
end

desc 'Run pacto validations against the default local development url'
task 'validate' do
  Rake::Task["pacto:validate"].invoke('http://localhost:4567', 'contracts')
end
