require 'spec_helper'
# require 'puppet//cgroups.rb'

describe 'cgroups::redhat', type: :class do
  context 'On RedHat' do
    let (:facts) do
      {
        osfamily: 'redhat',
        operatingsystem: 'CentOS'
      }
    end

    let (:params) do
      { cgroups_set: {
        'Apache' => { 'CPUShares' => 600, 'MemoryLimit' => '500M' }
      } }
    end

    it { is_expected.to compile }

    it { should contain_class('cgroups::redhat').with(cgroups_set: params[:cgroups_set]) }

    it { should contain_exec('/usr/bin/systemctl set-property Apache.service CPUShares=600') }
    it { should contain_exec('/usr/bin/systemctl set-property Apache.service MemoryLimit=500M') }
  end
end
