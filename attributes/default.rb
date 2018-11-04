# frozen_string_literal: true
# Generic
default['apt']['compile_time_update']                  = true
default['build-essential']['compile_time']             = true
default['java']['jdk_version']                         = '8'

# Crowd itself
default['crowd']['home_path']          = '/var/atlassian/application-data/crowd'
default['crowd']['install_path']       = '/opt/atlassian/crowd'
default['crowd']['install_type']       = 'standalone'
default['crowd']['version']            = '2.11.2'
default['crowd']['ssl']                = false
default['crowd']['user']               = 'crowd'
default['crowd']['group']              = 'crowd'
# TODO: needs to be done nicer but this is better then what is was :)
default['crowd']['pid']                = '/var/run/crowd.pid'

# JVM
default['crowd']['jvm']['minimum_memory']  = '512m'
default['crowd']['jvm']['maximum_memory']  = '1G'
default['crowd']['jvm']['maximum_permgen'] = '256m'
default['crowd']['jvm']['java_opts']       = ' -Djava.security.egd=file:///dev/urandom'
default['crowd']['jvm']['support_args']    = ''

# Database
# TODO: support MySQL 5.0.37+, Oracle 10.2.0.1+ / 11.2.0.2.0+
default['postgresql']['pg_gem']['version']             = '0.21.0'    # the 'database' cookbook doesn't work with 1.0.0
default['postgresql']['config_pgtune']['db_type']      = 'web'       # postgresql tuning for web
default['postgresql']['config_pgtune']['total_memory'] = '1048576kB' # limit max memory of the postgresql server to 1G
default['crowd']['database']['type']                   = 'postgresql'
default['crowd']['database']['version']                = '9.3'
default['crowd']['database']['host']                   = 'localhost'
default['crowd']['database']['name']                   = 'crowd'
default['crowd']['database']['password']               = 'changeit'
default['crowd']['database']['port']                   = 5432
default['crowd']['database']['user']                   = 'crowd'

# Proxy - Generic
default['crowd']['proxy']['enabled']        = false
default['crowd']['proxy']['type']           = 'nginx'
default['crowd']['proxy']['url']            = node['fqdn']
default['crowd']['proxy']['ssl_key']        = ''
default['crowd']['proxy']['ssl_key_path']   = ''
default['crowd']['proxy']['ssl_cert_path']  = ''
default['crowd']['proxy']['redirect']       = false

# Proxy - Apache
default['crowd']['apache2']['access_log']         = ''
default['crowd']['apache2']['error_log']          = ''
default['crowd']['apache2']['port']               = 80
default['crowd']['apache2']['virtual_host_alias'] = node['fqdn']
default['crowd']['apache2']['virtual_host_name']  = node['hostname']

# SSL
default['crowd']['apache2']['ssl']['access_log']       = ''
default['crowd']['apache2']['ssl']['chain_file']       = ''
default['crowd']['apache2']['ssl']['error_log']        = ''
default['crowd']['apache2']['ssl']['port']             = 443

case node['platform_family']
when 'rhel'
  default['crowd']['apache2']['ssl']['certificate_file'] = '/etc/pki/tls/certs/localhost.crt'
  default['crowd']['apache2']['ssl']['key_file']         = '/etc/pki/tls/private/localhost.key'
else
  default['crowd']['apache2']['ssl']['certificate_file'] = '/etc/ssl/certs/ssl-cert-snakeoil.pem'
  default['crowd']['apache2']['ssl']['key_file']         = '/etc/ssl/private/ssl-cert-snakeoil.key'
end

# Other / To cleanup
default['crowd']['tomcat']['port'] = '8095'

default['crowd']['applicationname'] = 'crowd'
default['crowd']['applicationpwd']  = ''
default['crowd']['serverid']        = ''
default['crowd']['license']         = ''
