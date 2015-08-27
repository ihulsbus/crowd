default['crowd']['home_path']          = '/var/atlassian/application-data/crowd'
default['crowd']['init_type']          = 'sysv'
default['crowd']['install_path']       = '/opt/atlassian'
default['crowd']['install_type']       = 'standalone'
default['crowd']['url_base']           = 'http://www.atlassian.com/software/crowd/downloads/binary/atlassian-crowd'
default['crowd']['version']            = '2.8.3'
default['crowd']['ssl']                = false
default['crowd']['user']               = 'crowd'
default['crowd']['group']              = 'crowd'

default['apt']['compile_time_update']               = true
default['build-essential']['compile_time']          = true

default['postgresql']['config_pgtune']['db_type']   = 'web'

default['crowd']['proxy']['enabled']        = true
default['crowd']['proxy']['type']           = 'nginx'
default['crowd']['proxy']['url']            = node['fqdn']
default['crowd']['proxy']['ssl_key']        = ''
default['crowd']['proxy']['ssl_key_path']   = ''
default['crowd']['proxy']['ssl_cert_path']  = ''
default['crowd']['proxy']['redirect']       = false

default['crowd']['applicationname']    = 'crowd'
default['crowd']['applicationpwd']     = ''
default['crowd']['serverid']           = ''
default['crowd']['license']            = ''

default['java']['jdk_version'] = '7'

if node['kernel']['machine'] == 'x86_64'
  default['crowd']['arch'] = 'x64'
else
  default['crowd']['arch'] = 'x32'
end

# rubocop:disable BlockNesting
case node['platform_family']
when 'debian'
  case node['crowd']['install_type']
  when 'standalone'
    default['crowd']['url']      = "#{node['crowd']['url_base']}-#{node['crowd']['version']}.tar.gz"
    default['crowd']['checksum'] =
      case node['crowd']['version']
      when '2.8.3' then 'dabfde01366c1f72d50440e69d38a3a2a5092a4cba525b3987af8d53b11a402c'
      when '2.8.2' then '250a46181cebe96624a59672b9f413d23e17195ca1fd6aafaff860951b5b89b4'
      when '2.8.0' then 'c857eb16f65ed99ab8b289fe671e3cea89140d42f85639304caa91a3ba9ade05'
      when '2.7.2' then '49361f2c7cbd8035c2fc64dfff098eb5e51d754b5645425770da14fc577f1048'
      end
  end
end
# rubocop:enable BlockNesting

default['crowd']['apache2']['access_log']         = ''
default['crowd']['apache2']['error_log']          = ''
default['crowd']['apache2']['port']               = 80
default['crowd']['apache2']['virtual_host_alias'] = node['fqdn']
default['crowd']['apache2']['virtual_host_name']  = node['hostname']

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

default['crowd']['database']['type']     = 'postgresql'
default['crowd']['database']['host']     = 'localhost'
default['crowd']['database']['name']     = 'crowd'
default['crowd']['database']['password'] = 'changeit'
default['crowd']['database']['port']     = 5432
default['crowd']['database']['user']     = 'crowd'

default['crowd']['jvm']['minimum_memory']  = '512m'
default['crowd']['jvm']['maximum_memory']  = '1024m'
default['crowd']['jvm']['maximum_permgen'] = '256m'
default['crowd']['jvm']['java_opts']       = ' -Djava.security.egd=file:///dev/urandom'
default['crowd']['jvm']['support_args']    = ''

default['crowd']['tomcat']['keyAlias']     = 'tomcat'
default['crowd']['tomcat']['keystoreFile'] = "#{node['crowd']['home_path']}/.keystore"
default['crowd']['tomcat']['keystorePass'] = 'changeit'
default['crowd']['tomcat']['port']         = '8095'
default['crowd']['tomcat']['ssl_port']     = '8443'
