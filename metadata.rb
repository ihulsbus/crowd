name             'crowd'
source_url       'https://github.com/katbyte/chef-crowd'
issues_url       'https://github.com/katbyte/chef-crowd/issues'
maintainer       'katbyte'
maintainer_email 'kt@katbyte.me'
license          'MIT'
description      'Manages an Atlassian Crowd installation'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.2.2'

chef_version '>= 12.18', '< 14.0'

recipe 'crowd::default',    'Installs/configures Atlassian CROWD'
recipe 'crowd::standalone', 'Installs/configures CROWD via standalone archive'
recipe 'crowd::database',   'Installs/configures MySQL/Postgres server, database, and user for CROWD'
recipe 'crowd::init',       'Installs/configures CROWD init service'
recipe 'crowd::apache2',    'Installs/configures Apache 2 as proxy (ports 80/443)'
recipe 'crowd::nginx',      'Installs/configures Nginx as proxy (ports 80/443)'

# Only tested on Ubuntu, YMMV on other platforms
%w(debian ubuntu).each do |os|
  supports os
end

depends 'apt'
depends 'apache2'
depends 'ark'
depends 'build-essential'
depends 'database'
depends 'patch'
depends 'java'
depends 'mysql', '>= 6.0'
depends 'mysql_connector'
depends 'mysql2_chef_gem'
depends 'nginx', '>=2.7.6'
depends 'nginx-proxy'
depends 'nokogiri'
depends 'ohai', '< 4.0.0' # fix for node['ohai']['plugin_path'] issue in nginx-proxy cookbook
depends 'postgresql', '< 7.0.0'
depends 'seven_zip', '~> 2.0'
