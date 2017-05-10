#
# Cookbook Name:: crowd
# Recipe:: database
#
# Copyright 2015, KLM Royal Dutch Airlines
#

settings = merge_crowd_settings

include_recipe 'build-essential'

case settings['database']['type']
when 'mysql'
  mysql2_chef_gem 'crowd' do
    client_version settings['database']['version'] if settings['database']['version']
    action :install
  end

  mysql_service 'crowd' do
    version settings['database']['version'] if settings['database']['version']
    bind_address settings['database']['host']
    port settings['database']['port'].to_s
    data_dir node['mysql']['data_dir'] if node['mysql']['data_dir']
    initial_root_password node['mysql']['server_root_password']
    action [:create, :start]
  end

  mysql_database settings['database']['name'] do
    connection crowd_database_connection
    collation 'utf8_bin'
    encoding 'utf8'
    action :create
  end

  # See this MySQL bug: http://bugs.mysql.com/bug.php?id=31061
  mysql_database_user '' do
    connection crowd_database_connection
    host 'localhost'
    action :drop
  end

  mysql_database_user settings['database']['user'] do
    connection crowd_database_connection
    host '%'
    password settings['database']['password']
    database_name settings['database']['name']
    action [:create, :grant]
  end

when 'postgresql'
  include_recipe 'postgresql::server'
  include_recipe 'database::postgresql'

  postgresql_database_user settings['database']['user'] do
    connection crowd_database_connection
    password settings['database']['password']
    action :create
  end

  postgresql_database settings['database']['name'] do
    connection crowd_database_connection
    connection_limit '-1'
    # See: https://crowd.atlassian.com/display/JIRAKB/Health+Check%3A+Database+Collation
    encoding 'utf8'
    collation 'C'
    template 'template0'
    owner settings['database']['user']
    action :create
  end

when 'hsqldb'
  # No-op. HSQLDB doesn't require any configuration.
  Chef::Log.warn('HSQLDB should not be used in production')
end
