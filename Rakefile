require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'yard'

desc 'Run Rosh in the console'
task :console do
  require 'irb'
  require 'irb/completion'
  require './lib/rosh' # You know what to do.
  ARGV.clear
  IRB.start
end

YARD::Rake::YardocTask.new do |t|
  t.files = %w[lib/**/*.rb - README.md History.md]
end

# Alias for rubygems-test
task test: :spec
