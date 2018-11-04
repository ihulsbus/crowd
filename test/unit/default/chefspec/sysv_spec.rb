# spec_helper is automatically included via Rakefile

describe 'crowd::init' do
  let :chef_run do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04').converge(described_recipe)
  end
end
