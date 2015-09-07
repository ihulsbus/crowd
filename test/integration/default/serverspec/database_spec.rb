require 'spec_helper'

describe service('postgresql') do
  it { should be_enabled }
  it { should be_running }
end
