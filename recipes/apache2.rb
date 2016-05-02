#
# Cookbook Name:: crowd
# Recipe:: apache2
#
# Copyright 2015, KLM Royal Dutch Airlines
#

node.set['apache']['listen'] = node['apache']['listen'] + ["*:#{node['crowd']['apache2']['port']}"] unless node['apache']['listen'].include?("*:#{node['crowd']['apache2']['port']}")
node.set['apache']['listen'] = node['apache']['listen'] + ["*:#{node['crowd']['apache2']['ssl']['port']}"] unless node['apache']['listen'].include?("*:#{node['crowd']['apache2']['ssl']['port']}")

include_recipe 'apache2'
include_recipe 'apache2::mod_proxy'
include_recipe 'apache2::mod_proxy_http'
include_recipe 'apache2::mod_ssl'

web_app node['crowd']['apache2']['virtual_host_name']
