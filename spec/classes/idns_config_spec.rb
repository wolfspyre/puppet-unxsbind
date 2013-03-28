require 'spec_helper'

describe 'idns::config' do
  let (:params) {{'ensure' => 'present'}}
  context "On a RedHat OS" do
    let :facts do
      { :osfamily => 'RedHat' }
    end
    configs = {
      'unxsbind_named_conf' => '/usr/local/idns/named.conf',
      'unxsbind_initscript' => '/etc/init.d/unxsbind'
    }
it { should contain_file('unxsbind_named_conf')}
    ['present', 'enabled', 'active','disabled','stopped'].each do |yesplease|
      context "when ensure has the value '#{yesplease}'" do
#        configs.each_pair do | filename, path |
#          it { should contain_file(filename)
#          }
#        end
      end
    end
    context "when ensure has the value 'absent'" do
      configs.each_pair do | filename, path |
        it { should_not contain_file(filename)}
      end
    end
  end
end