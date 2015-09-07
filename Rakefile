require 'foodcritic'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'rake/dsl_definition'

desc 'Run RuboCop style and lint checks'
RuboCop::RakeTask.new(:rubocop)

desc 'Run Foodcritic lint checks'
FoodCritic::Rake::LintTask.new(:foodcritic) do |t|
  t.options = {
    tags: %w(~FC001 ~FC022),
    fail_tags: ['any'],
    # include_rules: '',
    context: true
  }
end

desc 'Run ChefSpec unit tests'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern    = 'test/unit/**/*_spec.rb'
  t.rspec_opts = ' --require ./test/unit/default/chefspec/spec_helper.rb'
end

desc 'Run all tests'
task :lint => [:rubocop, :foodcritic]
task :test => [:lint, :spec]
task :default => :test
