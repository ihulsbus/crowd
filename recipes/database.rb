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

case settings['database']['type']
when 'postgresql'
  include_recipe 'build-essential'
  include_recipe 'postgresql::config_pgtune'
  include_recipe 'postgresql::server'
  include_recipe 'database::postgresql'
  database_connection.merge!(:username => 'postgres', :password => node['postgresql']['password']['postgres'])

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
