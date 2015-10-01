name             'chef_crowd'
maintainer       'KLM Royal Dutch Airlines'
maintainer_email 'martijn.vanderkleijn@klm.com'
license          'MIT'
description      'Installs/Configures Atlassian Crowd'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

recipe 'chef_crowd::default',    'Installs/configures Atlassian CROWD'
recipe 'chef_crowd::standalone', 'Installs/configures CROWD via standalone archive'
recipe 'chef_crowd::database',   'Installs/configures Postgres server, database, and user for CROWD'
recipe 'chef_crowd::sysv',       'Installs/configures CROWD SysV init service'
recipe 'chef_crowd::apache2',    'Installs/configures Apache 2 as proxy (ports 80/443)'
recipe 'chef_crowd::nginx',      'Installs/configures Nginx as proxy (ports 80/443)'

# Only tested on Ubuntu, YMMV on other platforms
%w( debian ubuntu ).each do |os|
  supports os
end

depends 'apt'
depends 'apache2'
depends 'ark'
depends 'database'
depends 'java'
depends 'build-essential'
depends 'nginx-proxy'
depends 'postgresql'
depends 'nokogiri'
