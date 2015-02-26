ark_prefix_path = ::File.dirname(node['crowd']['install_path']) if ::File.basename(node['crowd']['install_path']) == 'crowd'
ark_prefix_path ||= node['crowd']['install_path']
settings = Crowd.settings(node)

directory File.dirname(node['crowd']['home_path']) do
  owner 'root'
  group 'root'
  mode 00755
  action :create
  recursive true
end

user node['crowd']['user'] do
  comment 'CROWD Service Account'
  home node['crowd']['home_path']
  shell '/bin/bash'
  supports :manage_home => true
  system true
  action :create
end

execute 'Generating Self-Signed Java Keystore' do
  command <<-COMMAND
    #{node['java']['java_home']}/bin/keytool -genkey \
      -alias #{settings['tomcat']['keyAlias']} \
      -keyalg RSA \
      -dname 'CN=#{node['fqdn']}, OU=Example, O=Example, L=Example, ST=Example, C=US' \
      -keypass #{settings['tomcat']['keystorePass']} \
      -storepass #{settings['tomcat']['keystorePass']} \
      -keystore #{settings['tomcat']['keystoreFile']}
    chown #{node['crowd']['user']}:#{node['crowd']['user']} #{settings['tomcat']['keystoreFile']}
  COMMAND
  creates settings['tomcat']['keystoreFile']
  only_if { settings['tomcat']['keystoreFile'] == "#{node['crowd']['home_path']}/.keystore" }
end

directory ark_prefix_path do
  action :create
  recursive true
end

ark 'crowd' do
  url node['crowd']['url']
  prefix_root ark_prefix_path
  prefix_home ark_prefix_path
  checksum node['crowd']['checksum']
  version node['crowd']['version']
  owner node['crowd']['user']
  group node['crowd']['user']
end
