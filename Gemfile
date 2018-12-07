# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rake'

group :test, :integration do
  gem 'berkshelf', '~> 4.0'
end

group :test do
  gem 'chefspec'
  gem 'cookstyle'
  gem 'foodcritic'
  gem 'rspec'
  gem 'rubocop'
end

group :integration do
  gem 'kitchen-vagrant', '~> 0.15'
  gem 'test-kitchen', '~> 1.3'
end
