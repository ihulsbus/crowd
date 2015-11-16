require 'spec_helper'

describe service('crowd') do
  it { should be_enabled }
  it { should be_running }
end

describe port(8095) do
  it { should be_listening }
end
