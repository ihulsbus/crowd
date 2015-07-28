default['crowd']['home_path']          = '/var/atlassian/application-data/crowd'
default['crowd']['init_type']          = 'sysv'
default['crowd']['install_path']       = '/opt/atlassian/crowd'
default['crowd']['install_type']       = 'standalone'
default['crowd']['url_base']           = 'http://www.atlassian.com/software/crowd/downloads/binary/atlassian-crowd'
default['crowd']['version']            = '2.7.2'
default['crowd']['backup_when_update'] = false
default['crowd']['ssl']                = false

default['crowd']['proxy']                   = 'nginx'
default['crowd']['proxy']['url']            = node['hostname']
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

# default['crowd']['container_server']['name'] = 'tomcat'
# default['crowd']['container_server']['version'] = '6'
#
# default['crowd']['build']['targets'] = 'war'
# default['crowd']['build']['enable'] = true
# default['crowd']['build']['exclude_jars'] = %w(jcl-over-slf4j jul-to-slf4j log4j slf4j-api slf4j-log4j12)
# default['crowd']['build']['file'] = "#{node['crowd']['install_path']}/dist-#{node['crowd']['container_server']['name']}/atlassian-crowd-#{node['crowd']['version']}.war"

default['crowd']['database']['type']     = 'postgresql'
default['crowd']['database']['host']     = 'localhost'
default['crowd']['database']['name']     = 'crowd'
default['crowd']['database']['password'] = 'changeit'
default['crowd']['database']['port']     = 5432
default['crowd']['database']['user']     = 'crowd'

# default['crowd']['jars']['deploy_jars'] = %w(carol carol-properties hsqldb jcl-over-slf4j jonas_timer jotm jotm-iiops_stubs jotm-jmrp_stubs jta jul-to-slf4j log4j objectweb-datasource ots-jts slf4j-api slf4j-log4j12 xapool)
# default['crowd']['jars']['install_path'] = node['crowd']['install_path'] + '-jars'
# default['crowd']['jars']['url_base'] = 'http://www.atlassian.com/software/crowd/downloads/binary/crowd-jars'
# default['crowd']['jars']['version'] = node['crowd']['version'].split('.')[0..1].join('.')
# default['crowd']['jars']['url'] = "#{node['crowd']['jars']['url_base']}-#{node['crowd']['container_server']['name']}-distribution-#{node['crowd']['jars']['version']}-#{node['crowd']['container_server']['name']}-#{node['crowd']['container_server']['version']}x.zip"

default['crowd']['jvm']['minimum_memory']  = '512m'
default['crowd']['jvm']['maximum_memory']  = '1024m'
default['crowd']['jvm']['maximum_permgen'] = '256m'
default['crowd']['jvm']['java_opts']       = ''
default['crowd']['jvm']['support_args']    = ''

# default['crowd']['tomcat']['keyAlias']     = 'tomcat'
# default['crowd']['tomcat']['keystoreFile'] = "#{node['crowd']['home_path']}/.keystore"
# default['crowd']['tomcat']['keystorePass'] = 'changeit'
# default['crowd']['tomcat']['port']         = '8095'
# default['crowd']['tomcat']['ssl_port']     = '8443'
#
# default['crowd']['war']['file'] = node['crowd']['build']['file']
#
# case node['crowd']['container_server']['name']
# when 'tomcat'
#   if node['crowd']['install_type'] == 'war'
#     default['crowd']['context'] = 'crowd'
#     begin
#       default['crowd']['context_path'] = node['tomcat']['context_dir']
#       default['crowd']['lib_path'] = node['tomcat']['lib_dir']
#       default['crowd']['user'] = node['tomcat']['user']
#     rescue
#       default['crowd']['context_path'] = "/usr/share/tomcat#{node['crowd']['container_server']['version']}/conf/Catalina/localhost"
#       default['crowd']['lib_path'] = "/usr/share/tomcat#{node['crowd']['container_server']['version']}/lib"
#       default['crowd']['user'] = 'tomcat'
#     end
#   else
#     default['crowd']['context'] = ''
#     default['crowd']['context_path'] = "#{node['crowd']['install_path']}/conf/Catalina/localhost"
#     default['crowd']['lib_path'] = "#{node['crowd']['install_path']}/lib"
#     default['crowd']['user'] = 'crowd'
#   end
# end
