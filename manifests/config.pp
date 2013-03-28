# == Class: idns::config
#  wrapper class
#Class['idns::config']
class idns::config (
  $ensure = $idns::ensure
){
#  File{} -> Anchor['idns::end']
#  case $ensure {
#    present, enabled, active, disabled, stopped: {
      file { 'unxsbind_named_conf':
        ensure  => 'present',
        content => "blah",#template('idns/usr/local/idns/named.conf.erb'),
        path    => '/usr/local/idns/named.conf',
      }#end  unxsbind named.conf file
      file { 'unxsbind_initscript':
        ensure => 'present',
        path   => '/etc/init.d/unxsbind'
      }#End init file
    }#end configfiles should be present case
    absent: {
      file { 'unxsbind_named_conf':
        ensure  => 'absent',
        path    => '/usr/local/idns/named.conf',
      }#end idnsd.conf file
      file { 'unxsbind_initscript':
        ensure => 'absent',
        path   => '/etc/init.d/unxsbind'
      }#End init file
      file {'idns_logfile':
        ensure  => 'absent',
        path    => $logfile,
      }#end idns logfile file
    }#end configfiles should be absent case
    default: {
      notice "idns::ensure has an unsupported value of ${idns::ensure}."
    }#end default ensure case
  }#end ensure case
}#end class
