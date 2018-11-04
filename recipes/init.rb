# frozen_string_literal: true
#
# Cookbook Name:: crowd
# Recipe:: init
#
# Copyright 2015, KLM Royal Dutch Airlines
#

if node['init_package'] == 'systemd'

  execute 'systemctl-daemon-reload' do
    command '/bin/systemctl --system daemon-reload'
    action :nothing
  end

  template '/etc/systemd/system/crowd.service' do
    source 'crowd.systemd.erb'
    mode '0644'
    notifies :run, 'execute[systemctl-daemon-reload]', :immediately
    notifies :restart, 'service[crowd]', :delayed
  end

else

  template '/etc/init.d/crowd' do
    source 'crowd.init.erb'
    mode '0755'
    notifies :restart, 'service[crowd]', :delayed
  end

end

service 'crowd' do
  supports :status => true, :restart => true
  action :enable
  subscribes :restart, 'java_ark[jdk]'
end
