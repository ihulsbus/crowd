#
# Cookbook Name:: crowd
# Recipe:: database
#
# Copyright 2015, KLM Royal Dutch Airlines
#

settings = Crowd.settings(node)

database_connection = {
  :host => settings['database']['host'],
  :port => settings['database']['port']
}

include_recipe 'build-essential'

case settings['database']['type']
when 'mysql'
  directory "#{node[:crowd][:home_dir]}/lib" do
    owner node[:crowd][:user]
    group node[:crowd][:group]
    mode 0775
    action :create
  end

  mysql_connector_j "#{node[:crowd][:home_dir]}/lib"

  mysql_client 'default' do
    action :create
  end

  mysql_service 'default' do
    version '5.6'
    bind_address settings[:database][:host]
    port settings[:database][:port]
    data_dir node[:mysql][:data_dir] if node[:mysql][:data_dir]
    initial_root_password node[:mysql][:server_root_password]
    action [:create, :start]
  end

  database_connection[:username] = node[:bamboo][:database][:root_user_name]
  database_connection[:password] = node[:mysql][:server_root_password]

  mysql_database settings[:database][:name] do
    connection database_connection
    collation 'utf8_bin'
    encoding 'utf8'
    action :create
  end

  mysql_database settings[:database][:name] do
    connection database_connection
    collation 'utf8_bin'
    encoding 'utf8'
    action :create
  end

when 'postgresql'
  include_recipe 'postgresql::config_pgtune'
  include_recipe 'postgresql::server'
  include_recipe 'database::postgresql'
  database_connection[:username] = 'postgres'
  database_connection[:password] = node['postgresql']['password']['postgres']

  postgresql_database settings['database']['name'] do
    connection database_connection
    connection_limit '-1'
    encoding 'utf8'
    action :create
  end

  postgresql_database_user settings['database']['user'] do
    connection database_connection
    password settings['database']['password']
    database_name settings['database']['name']
    action [:create, :grant]
  end
end
