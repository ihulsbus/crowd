require 'spec_helper.rb'

describe 'crowd::nginx' do
  before(:each) do
    # stub_command("ls /var/lib/postgresql/9.3/main/recovery.conf").and_return(false)
    stub_command("cat /opt/atlassian/crowd/apache-tomcat/conf/server.xml | grep RemoteIpValve").and_return(false)
    stub_command("which nginx").and_return('/usr/sbin/nginx')
  end

  let :chef_run do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04').converge(described_recipe)
  end

  # it 'installs zlib1g-dev with an explicit install action' do
  #   # expect(chef_run).to do_nothing
  #   expect(chef_run).to install_apt_package('zlib1g-dev')
  # end
end
