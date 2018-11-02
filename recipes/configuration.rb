#
# Cookbook Name:: crowd
# Recipe:: configuration
#
# Copyright 2015, KLM Royal Dutch Airlines
#

directory node['crowd']['home_path'] do
  owner node['crowd']['user']
  action :create
  recursive true
end

# Only needed for standalone
if node['crowd']['install_type'] == 'standalone'
  include_recipe 'patch'

  replace "#{node['crowd']['install_path']}/crowd-webapp/WEB-INF/classes/crowd-init.properties" do
    replace '#crowd.home=/var/crowd-home'
    with    "crowd.home=#{node['crowd']['home_path']}"
  end

  template "#{node['crowd']['install_path']}/apache-tomcat/bin/setenv.sh" do
    source 'setenv.sh.erb'
    mode '0744'
    owner node['crowd']['user']
    group node['crowd']['user']
    notifies :restart, 'service[crowd]', :delayed
  end

  template node['crowd']['pid'] do
    source 'crowd.pid.erb'
    mode '0644'
    owner node['crowd']['user']
    group node['crowd']['user']
    not_if { File.exist?(node['crowd']['pid']) }
  end
end
