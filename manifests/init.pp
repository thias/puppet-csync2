# Class: csync2
#
# Main csync2 class.
#
# Sample Usage :
#  include csync2
#
class csync2 (
  $cfg_source = undef,
  $cfg_content = undef,
  $ssl_cert_source = undef,
  $ssl_cert_content = undef,
  $ssl_key_source = undef,
  $ssl_key_content = undef,
  $xinetd = true,
  # Only used if $xinetd is true
  $port = '30865',
  $only_from = '10.0.0.0/8 172.16.0.0/12 192.168.0.0/16'
) {

  package { 'csync2': ensure => installed }

  # Configuration, certificate and private key
  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    require => Package['csync2'],
   }
  file { '/etc/csync2/csync2.cfg':
    $source  => $cfg_source,
    $content => $cfg_content,
  }
  file { '/etc/csync2/csync2_ssl_cert.pem':
    $source  => $ssl_cert_source,
    $content => $ssl_cert_content,
  }
  file { '/etc/csync2/csync2_ssl_key.pem':
    $source  => $ssl_key_source,
    $content => $ssl_key_content,
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

