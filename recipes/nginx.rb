# Install compile-time dependencies
package 'zlib1g-dev' do
  action :nothing
end.run_action(:install)
include_recipe 'nokogiri::chefgem'

# Edit the server.xml so the proxy + Bamboo works properly to allow HTTPS
ruby_block 'Editconfig' do
  block do
    require 'nokogiri'
    f = File.read("#{node['crowd']['install_path']}/crowd/apache-tomcat/conf/server.xml")
    doc = Nokogiri::XML(f)
    doc.xpath('/Server/Service/Engine[@name="Catalina"]').each do |change|
      valve = Nokogiri::XML::Node.new 'Valve', doc
      valve['className'] = 'org.apache.catalina.valves.RemoteIpValve'
      valve['remoteIpHeader'] = 'X-Forwarded-For'
      valve['requestAttributesEnabled'] = 'true'
      valve['internalProxies'] = '127.0.0.1'
      change.add_child(valve)
    end
    File.open("#{node['crowd']['install_path']}/crowd/apache-tomcat/conf/server.xml", 'w') { |f| f.print(doc.to_xml) }
  end
  not_if("cat #{node['crowd']['install_path']}/crowd/apache-tomcat/conf/server.xml | grep RemoteIpValve")
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
