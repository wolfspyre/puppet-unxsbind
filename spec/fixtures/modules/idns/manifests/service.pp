# == Class: idns::rhel::service
#  wrapper class
class idns::service {
  Service{} -> Anchor['idns::end']
  $packagename        = $idns::packagename
  # end of variables
  case $idns::ensure {
    enabled, active: {
      #everything should be installed, but puppet is not managing the state of the service
      service {'idns':
        ensure    => running,
        enable    => true,
        subscribe => File['idns_conf'],
        require   => Package[$packagename],
        hasstatus => true,
      }#end service definition
    }#end enabled class
    disabled, stopped: {
      service {'idns':
        ensure    => stopped,
        enable    => false,
        subscribe => File['idns_conf'],
        hasstatus => true,
      }#end service definition
    }#end disabled
    default: {
      #nothing to do, puppet shouldn't care about the service
    }#end default ensure case
  }#end ensure case
}#end class
