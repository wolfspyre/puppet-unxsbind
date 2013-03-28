# == Class: idns::rhel::service
#  wrapper class
class idns::service {
  Service{} -> Anchor['idns::end']
  $packagename        = $idns::packagename
  # end of variables
  case $idns::ensure {
    'enabled', 'active': {
      #everything should be installed
      service {'unxsbind':
        ensure    => true,
        enable    => true,
        subscribe => [File['unxsbind_named_conf'],Package['unxsbind']],
        require   => Package[$packagename],
        hasstatus => true,
      }#end service definition
    }#end enabled class
    'disabled', 'stopped': {
      service {'unxsbind':
        ensure    => stopped,
        enable    => false,
        subscribe => [File['unxsbind_named_conf'],Package['unxsbind']],
        hasstatus => true,
      }#end service definition
    }#end disabled
    default: {
      #nothing to do, puppet shouldn't care about the service
    }#end default ensure case
  }#end ensure case
}#end class
