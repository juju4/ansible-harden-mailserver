require 'serverspec'

# Required by serverspec
set :backend, :exec

describe service('postfix') do
  it { should be_enabled   }
  it { should be_running   }
end

describe package('postfix-policyd-spf-python'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end
describe package('pypolicyd-spf'), :if => os[:family] == 'redhat' do
  it { should be_installed }
end
## not enabled by default
#describe package('postgrey') do
#  it { should be_installed }
#end

describe port(25) do
  it { should be_listening.on('127.0.0.1').with('tcp') }
end

describe file('/etc/postfix/main.cf') do
  it { should be_file }
  its(:content) { should match /smtpd_banner = \$myhostname ESMTP Sorry, No banner/ }
  its(:content) { should match /smtpd_use_tls=yes/ }
end

describe command('echo | openssl s_client -starttls smtp -connect localhost:25 -cipher "EDH" 2>/dev/null | grep -ie "Server Temp key"') do
  its(:stdout) { should match /2048 bit/ }
end
describe command('echo | openssl s_client -starttls smtp -connect localhost:25 -cipher "EDH" 2>/dev/null | grep -ie "Server public key"') do
  its(:stdout) { should match /2048 bit/ }
end
