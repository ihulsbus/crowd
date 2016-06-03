require 'serverspec'
require 'json'

set :backend, :exec

$node = ::JSON.parse(File.read('/tmp/test-helper/node.json'))

shared_examples_for 'nginx' do
  describe service('nginx') do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(80) do
    it { should be_listening }
  end
end

shared_examples_for 'apache2' do
  describe service($node['apache']['service_name']) do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(80) do
    it { should be_listening }
  end
end


shared_examples_for 'postgresql' do
  describe service('postgresql') do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(5432) do
    it { should be_listening }
  end
end

shared_examples_for 'standalone' do
  describe service('crowd') do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(8095) do
    it { should be_listening }
  end
end
