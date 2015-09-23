#
# Cookbook Name:: crowd
# Recipe:: default
#
# Copyright 2015, KLM Royal Dutch Airlines
#

case node['platform_family']
when 'debian'
  include_recipe 'apt'
end

settings = Crowd.settings(node)

include_recipe 'build-essential'
include_recipe 'java'
include_recipe 'chef_crowd::database' if settings['database']['host'] == 'localhost'
include_recipe "chef_crowd::#{node['crowd']['install_type']}"
include_recipe "chef_crowd::#{node['crowd']['init_type']}"
include_recipe 'chef_crowd::configuration'

# Install the proxy in front of Crowd, if any.
unless node['crowd']['proxy']['enabled'] == false
  include_recipe "chef_crowd::#{node['crowd']['proxy']['type']}"
end
