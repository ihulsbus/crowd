name             'crowd'
source_url       'https://github.com/afklm/crowd'
issues_url       'https://github.com/afklm/crowd/issues'
maintainer       'KLM Royal Dutch Airlines'
maintainer_email 'martijn.vanderkleijn@klm.com'
license          'MIT'
description      'Installs/Configures Atlassian Crowd'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.2.2'

recipe 'crowd::default',    'Installs/configures Atlassian CROWD'
recipe 'crowd::standalone', 'Installs/configures CROWD via standalone archive'
recipe 'crowd::database',   'Installs/configures MySQL/Postgres server, database, and user for CROWD'
recipe 'crowd::sysv',       'Installs/configures CROWD SysV init service'
recipe 'crowd::apache2',    'Installs/configures Apache 2 as proxy (ports 80/443)'
recipe 'crowd::nginx',      'Installs/configures Nginx as proxy (ports 80/443)'

# Only tested on Ubuntu, YMMV on other platforms
%w[debian ubuntu].each do |os|
  supports os
end

depends 'apt'
depends 'apache2'
depends 'ark'
depends 'database'
depends 'patch'
depends 'ohai', '< 4.0.0' # fix for node['ohai']['plugin_path'] issue in nginx-proxy cookbook
depends 'java'
depends 'mysql', '>= 6.0'
depends 'mysql_connector'
depends 'mysql2_chef_gem'
depends 'build-essential'
depends 'nginx', '>=2.7.6'
depends 'nginx-proxy'
depends 'nokogiri'
depends 'postgresql', '>= 3.4.16'
