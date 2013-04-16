# Class: csync2
#
# Main csync2 class.
#
# Sample Usage :
#  include csync2
#
class csync2 (
  $cfg_source  = undef,
  $cfg_content = undef,
  $key_source  = undef,
  $key_content = undef,
  $xinetd      = true,
  # Only used if $xinetd is true
  $port        = '30865',
  $only_from   = '10.0.0.0/8 172.16.0.0/12 192.168.0.0/16'
) {

  package { 'csync2': ensure => installed }

  # Optional main configuration and main key files
  if $cfg_source or $cfg_content {
    csync2::cfg { 'MAIN':
      source  => $cfg_source,
      content => $cfg_content,
    }
  } else {
    csync2::cfg { 'MAIN':
      ensure => absent,
    }
  }
  if $key_source or $key_content {
    csync2::key { 'MAIN':
      source  => $key_source,
      content => $key_content,
    }
  } else {
    csync2::key { 'MAIN':
      ensure => absent,
    }
  }

  # Mandatory xinetd service, optionally managed here
  if $xinetd == true {
    xinetd::serviceconf { 'csync2':
      service_type => 'UNLISTED',
      flags        => 'REUSE',
      server       => '/usr/sbin/csync2',
      server_args  => '-i',
      port         => $port,
      only_from    => $only_from,
      require      => Package['csync2'],
    }
  }

}

