# Define: csync2::cfg
#
# Simple definition to manage pre-created csync2 configuration files.
#
# Sample Usage :
#  csync2::cfg { 'group1':
#    source => 'puppet://modules/mymodule/csync2/group1.cfg',
#  }
#
define csync2::cfg (
  $source  = undef,
  $content = undef,
  $ensure  = undef
) {

  $filename = $title ? {
    'MAIN'  => "csync2.cfg",
    default => "csync2_${title}.cfg",
  }

  file { "/etc/csync2/${filename}":
    source  => $source,
    content => $content,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    require => Package['csync2'],
    ensure  => $ensure,
  }

}

