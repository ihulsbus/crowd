source 'https://rubygems.org'

gem 'berkshelf',  :group => %I(production integration)
gem 'chef',       :group => %I(production test integration)

group :production do
  gem 'kitchen-openstack'
end

group :integration do
  gem 'kitchen-vagrant'
  gem 'test-kitchen'
end

group :test do
  gem 'chefspec'
  gem 'foodcritic', '>=3.0.5'
  gem 'cookstyle',  '~> 2.1'
  gem 'rubocop'
  gem 'rake'
  gem 'rspec'
end

group :foss do
  gem 'stove'
end
