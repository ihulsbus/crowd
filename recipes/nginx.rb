# frozen_string_literal: true
#
# Cookbook Name:: crowd
# Recipe:: nginx
#
# Copyright 2015, KLM Royal Dutch Airlines
#

# Install compile-time dependencies for nokogiri
case node['platform_family']
when 'debian'
  zlib_pkg = 'zlib1g-dev'
when 'rhel'
  zlib_pkg = 'zlib-devel'
else
  Chef::Log.fail("Your platform family (#{node['platform_family']}) does not have a zlib-dev package specified.")
end

package zlib_pkg do
  action :nothing
end.run_action(:install)
include_recipe 'nokogiri::chefgem'

# Edit the server.xml compres responses
ruby_block 'compression' do
  block do
    require 'nokogiri'
    file = File.read("#{node['crowd']['install_path']}/apache-tomcat/conf/server.xml")
    doc = Nokogiri::XML(file)
    doc.xpath('/Server/Service/Connector[@port="8095"]').each do |change|
      next unless change.name == 'Connector'
      change['compression'] = 'on'
      change['compressableMimeType'] = 'text/html,text/xml,text/plain,text/css,application/json,application/javascript,application/x-javascript'
    end
    File.open("#{node['crowd']['install_path']}/apache-tomcat/conf/server.xml", 'w') { |f| f.print(doc.to_xml) }
  end
  not_if("cat #{node['crowd']['install_path']}/apache-tomcat/conf/server.xml | grep compression")
end

# Edit the server.xml so the proxy + Crowd works properly to allow HTTPS
ruby_block 'remoteIpValve' do
  block do
    require 'nokogiri'
    file = File.read("#{node['crowd']['install_path']}/apache-tomcat/conf/server.xml")
    doc = Nokogiri::XML(file)
    doc.xpath('/Server/Service/Engine[@name="Catalina"]').each do |change|
      valve = Nokogiri::XML::Node.new 'Valve', doc
      valve['className'] = 'org.apache.catalina.valves.RemoteIpValve'
      valve['remoteIpHeader'] = 'X-Forwarded-For'
      valve['requestAttributesEnabled'] = 'true'
      valve['internalProxies'] = '127.0.0.1'
      change.add_child(valve)
    end
    File.open("#{node['crowd']['install_path']}/apache-tomcat/conf/server.xml", 'w') { |f| f.print(doc.to_xml) }
  end
  not_if("cat #{node['crowd']['install_path']}/apache-tomcat/conf/server.xml | grep RemoteIpValve")
end

nginx_proxy node['crowd']['proxy']['url'] do
  url 'http://localhost:8095'
  if node['crowd']['ssl']
    ssl_key node['crowd']['proxy']['ssl_key']
    ssl_key_path node['crowd']['proxy']['ssl_key_path']
    ssl_certificate_path node['crowd']['proxy']['ssl_cert_path']
  end

  redirect node['crowd']['proxy']['redirect']
end

nginx_site 'default' do
  enable false
  only_if 'test -L /etc/nginx/sites-enabled/default'
end
