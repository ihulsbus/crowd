require 'spec_helper'

describe 'database' do
  it_behaves_like 'postgresql'
end

describe 'webserver' do
  it_behaves_like 'nginx'
end

describe 'crowd' do
  it_behaves_like 'standalone'
end
