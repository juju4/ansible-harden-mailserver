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
  its(:content) { should match /smtpd_use_tls = yes/ }
end

describe command('postconf') do
  its(:stdout) { should match /smtpd_use_tls = yes/ }
  its(:stdout) { should match /disable_vrfy_command = yes/ }
  its(:stderr) { should_not match /warning/ }
  its(:stderr) { should_not match /fatal/ }
  its(:exit_status) { should eq 0 }
end

describe command('echo | openssl s_client -starttls smtp -connect localhost:25'), :if => os[:family] != 'ubuntu' || os[:release] != '18.04' do
  its(:stdout) { should match /CONNECTED/ }
  its(:stdout) { should match /SSL handshake has read/ }
  its(:stdout) { should match /Protocol  : TLSv1.2/ }
end

describe command('echo | openssl s_client -starttls smtp -connect localhost:25'), :if => os[:family] == 'ubuntu' && os[:release] == '18.04' do
  its(:stdout) { should match /CONNECTED/ }
  its(:stdout) { should match /SSL handshake has read/ }
  its(:stdout) { should match /Protocol  : TLSv1.3/ }
end

# FIXME! on centos7, got 'CONNECTED' and hold...
describe command('echo | timeout 15 openssl s_client -starttls smtp -connect localhost:25 -cipher "EDH"'), :if => os[:family] != 'redhat' && os[:release] != '18.04' do
  its(:stdout) { should match /CONNECTED/ }
  its(:stdout) { should match /Server Temp key: DH, 2048 bits/i }
  its(:stdout) { should match /Server public key.*2048 bit/i }
end

describe command('echo | timeout 15 openssl s_client -starttls smtp -connect localhost:25 -cipher "EDH"'), :if => os[:family] == 'ubuntu' && os[:release] == '18.04' do
  its(:stdout) { should match /CONNECTED/ }
  its(:stdout) { should match /Server Temp Key: X25519, 253 bits/i }
  its(:stdout) { should match /Server public key.*2048 bit/i }
end

