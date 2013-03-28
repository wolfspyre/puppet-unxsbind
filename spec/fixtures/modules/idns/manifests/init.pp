# == Class: idns
#
# Full description of class idns here.
#
# === Parameters
#
# Document parameters here.
#
# [*create_repo*]
#   Whether or not to create the yumrepo
#
# [*ensure*]
#   Defines what to do with idns. Supported values:
#     present, enabled, active, disabled, stopped, absent
#
# [*packagename*]
#    The name of the package
#
# [*repo_hash*]
#   A hash containing the yum repo attributes
#
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { idns:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2011 Your name here, unless otherwise noted.
#
class idns(
  $create_repo = false,
  $ensure      = hiera('idns::ensure', 'present'),
  $packagename = 'unxsbind',
  $repo_hash   = hiera('idns::repo_hash', unxsVZ => {
    descr => 'unxsVZ Repository',
    baseurl => 'http://unixservice.com/rpm/',
    gpgcheck => '0' })
){
  Yumrepo {
    notify  => Exec['idns_yum_clean_metadata'],
    require => Anchor['idns::begin'],
    before  => Anchor['idns::end'],
  }
  exec { 'idns_yum_clean_metadata':
    command     => '/usr/bin/yum clean metadata',
    refreshonly => true,
    before      => Class['idns::package']
  }#end metadata cleaning exec
  case $ensure {
    present, enabled, active, disabled, stopped:{
      if $create_repo {
        create_resources('yumrepo', $repo_hash )
        $repofile = keys($repo_hash)
        idns::add_repo_file{ $repofile: }
      }
    }
    absent:{
    }
    default:{ fail("Unsupported value of ${ensure} set. Valid options are present, enabled, active, disabled, stopped, absent")
    }
  }
  #take advantage of the Anchor pattern
  anchor{'idns::begin':
    before => Class['idns::package'],
  }
  anchor {'idns::end':
    require => [
      Class['idns::package'],
      Class['idns::config'],
      Class['idns::service'],
    ],
  }
  Class['idns::package'] -> Class['idns::config']
  Class['idns::package'] -> Class['idns::service']
  Class['idns::config']  -> Class['idns::service']
  include idns::config
  include idns::package
  include idns::service
}