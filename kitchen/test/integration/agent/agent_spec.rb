control 'khulnasoft-agent' do
  title 'Khulnasoft agent tests'
  describe 'Checks Khulnasoft agent correct version, services and daemon ownership'

  describe package('khulnasoft-agent') do
    it { is_expected.to be_installed }
    its('version') { is_expected.to eq '4.8.0-1' }
  end

  describe service('khulnasoft-agent') do
    it { is_expected.to be_installed }
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  # Verifying daemons
  khulnasoft_daemons = {
    'khulnasoft-agentd' => 'khulnasoft',
    'khulnasoft-execd' => 'root',
    'khulnasoft-modulesd' => 'root',
    'khulnasoft-syscheckd' => 'root',
    'khulnasoft-logcollector' => 'root'
  }

  khulnasoft_daemons.each do |key, value|
    describe processes(key) do
      its('users') { is_expected.to eq [value] }
    end
  end
end
