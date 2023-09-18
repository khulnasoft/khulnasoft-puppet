control 'khulnasoft-manager' do
  title 'Khulnasoft manager tests'
  describe 'Checks Khulnasoft manager correct version, services and daemon ownership'

  describe package('khulnasoft-manager') do
    it { is_expected.to be_installed }
    its('version') { is_expected.to eq '4.8.0-1' }
  end

  # Verifying service
  describe service('khulnasoft-manager') do
    it { is_expected.to be_installed }
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  # Verifying daemons
  khulnasoft_daemons = {
    'khulnasoft-authd' => 'root',
    'khulnasoft-execd' => 'root',
    'khulnasoft-analysisd' => 'khulnasoft',
    'khulnasoft-syscheckd' => 'root',
    'khulnasoft-remoted' => 'khulnasoft',
    'khulnasoft-logcollector' => 'root',
    'khulnasoft-monitord' => 'khulnasoft',
    'khulnasoft-db' => 'khulnasoft',
    'khulnasoft-modulesd' => 'root',
  }

  khulnasoft_daemons.each do |key, value|
    describe processes(key) do
      its('users') { is_expected.to eq [value] }
    end
  end
end
