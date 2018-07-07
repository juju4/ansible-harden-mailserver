require 'serverspec'

# Required by serverspec
set :backend, :exec

describe file('/etc/aliases') do
  it { should be_file }
  its(:content) { should match /^support: root$/ }
  its(:content) { should match /^noc: root$/ }
  its(:content) { should match /^abuse: root$/ }
end
