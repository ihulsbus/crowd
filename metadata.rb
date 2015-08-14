name             'crowd'
maintainer       'KLM Royal Dutch Airlines'
maintainer_email 'martijn.vanderkleijn@klm.com'
license          'MIT'
description      'Installs/Configures Atlassian Crowd'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.5.2'

recipe 'crowd', 'Installs/configures Atlassian CROWD'
recipe 'crowd::apache2', 'Installs/configures Apache 2 as proxy (ports 80/443)'
recipe 'crowd::nginx', 'Installs/configures Nginx as proxy (ports 80/443)'
recipe 'crowd::database', 'Installs/configures Postgres server, database, and user for CROWD'
recipe 'crowd::standalone', 'Installs/configures CROWD via standalone archive'
recipe 'crowd::sysv', 'Installs/configures CROWD SysV init service'

depends 'apt'
depends 'apache2'
depends 'ark'
depends 'database'
depends 'java'
depends 'build-essential'
depends 'nginx-proxy'
depends 'postgresql'
depends 'nokogiri'

suggests 'tomcat'

supports 'ubuntu', '>= 14.04'
