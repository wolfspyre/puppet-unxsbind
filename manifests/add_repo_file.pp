#This simply adds a file to yum.repos.d to prevent the file from being removed
define idns::add_repo_file() {
  file { "yumrepo_${title}":
    ensure => 'file',
    path   => "/etc/yum.repos.d/${title}.repo",
    owner  => 'root',
    group  => 'root',
    mode   => '0444',
  }
}
