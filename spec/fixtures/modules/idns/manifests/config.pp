# == Class: idns::config
#  wrapper class
#Class['idns::config']
class idns::config {
  #make our parameters local scope
  File{} -> Anchor['idns::end']
  #clean up our parameters
  $ensure             = $idns::ensure
  case $ensure {
    present, enabled, active, disabled, stopped: {
    }#end configfiles should be present case
    absent: {
      file {'idns_conf':
        ensure  => 'absent',
        path    =>  $configfilepath,
      }#end idnsd.conf file
      file {'/etc/init.d/idns':
        ensure => 'absent',
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
