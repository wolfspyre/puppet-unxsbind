# == Class: idns::rhel::package
#  wrapper class
#
class idns::package {
  Package{} -> Anchor['idns::end']
  $packagename        = $idns::packagename
  # end of variables
  case $idns::ensure {
    present, enabled, active, disabled, stopped: {
      #everything should be installed
      package { $packagename:
        ensure => 'present',
      }
    }#end present case
    absent: {
      #everything should be removed
      package { $packagename:
        ensure => 'absent',
      }
    }#end absent case
    default: {
      notice "idns::ensure has an unsupported value of ${idns::ensure}."
    }#end default ensure case
  }#end ensure case
}#end class
