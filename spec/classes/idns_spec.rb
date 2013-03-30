require 'spec_helper'

describe 'idns', :type => :class do
  context "On a RedHat OS" do
    let :facts do
      { :osfamily => 'RedHat' }
    end
    ['present', 'enabled', 'active'].each do |yesplease|
      context "when ensure has the value '#{yesplease}'" do
        [true,false].each do |createrepo|
          context "and create_repo is #{createrepo}" do
            let (:params) do
              {'ensure' => yesplease,
              'create_repo' => createrepo,
              'repo_hash'   => {'unxsVZ' => {
                  'descr' => 'unxsVZ Repository',
                  'baseurl' => 'http://unixservice.com/rpm/',
                  'gpgcheck' => '0'
                }}
              }
            end
            it {
              if ((yesplease == 'enabled') or (yesplease == 'active'))
                should contain_service('unxsbind')
              else
                should_not contain_service('unxsbind')
              end
            }
            it { should contain_package('unxsbind') }
            it {
              if createrepo
                should contain_yumrepo('unxsVZ')
              else
                should_not contain_yumrepo('unxsVZ')
              end
            }
          end
        end
      end
    end
    it { should include_class('idns::config') }
    it { should include_class('idns::package') }
    it { should include_class('idns::service') }
  end
end