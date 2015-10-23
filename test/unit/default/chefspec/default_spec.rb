# spec_helper is automatically included via Rakefile

describe 'crowd::default' do
  before(:each) do
    stub_command('ls /var/lib/postgresql/9.3/main/recovery.conf').and_return(false)
    stub_command('cat /opt/atlassian/crowd/apache-tomcat/conf/server.xml | grep RemoteIpValve').and_return(false)
    stub_command('which nginx').and_return('/usr/sbin/nginx')
  end

  let :chef_run do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04') do |node|
      # Needed for testing postgresql cookbook
      node.set['postgresql']['password']['postgres'] = 'pswpsw123'
    end.converge(described_recipe)
  end

  it 'should include the apt::default recipe when platform is debian-based' do
    expect(chef_run).to include_recipe('apt::default')
  end
end
