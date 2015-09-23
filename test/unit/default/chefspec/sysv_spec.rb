# spec_helper is automatically included via Rakefile

describe 'chef_crowd::sysv' do
  let :chef_run do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04').converge(described_recipe)
  end

  it 'creates a crowd init script' do
    expect(chef_run).to create_template('/etc/init.d/crowd').with(mode: '0755')
  end

  it 'enables the crowd service with attributes' do
    expect(chef_run).to enable_service('crowd').with(supports: { :status => :true, :restart => :true })
  end
end
