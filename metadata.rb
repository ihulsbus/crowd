name             'crowd'
maintainer       'KLM Royal Dutch Airlines'
maintainer_email 'martijn.vanderkleijn@klm.com'
license          'MIT'
description      'Installs/Configures Atlassian Crowd'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.3'

recipe 'crowd', 'Installs/configures Atlassian CROWD'
recipe 'crowd::apache2', 'Installs/configures Apache 2 as proxy (ports 80/443)'
recipe 'crowd::database', 'Installs/configures Postgres server, database, and user for CROWD'
recipe 'crowd::standalone', 'Installs/configures CROWD via standalone archive'
recipe 'crowd::sysv', 'Installs/configures CROWD SysV init service'

depends 'apt'
depends 'apache2'
depends 'ark'
depends 'database'
depends 'java'
# depends 'mysql'
# depends 'mysql_connector'
depends 'postgresql'

suggests 'tomcat'

# supports 'centos', '>= 6.0'
# supports 'redhat', '>= 6.0'
supports 'ubuntu', '>= 14.04'
