# Class: arc_ce
# Sets up the configuration file and file dependencies.
class argus_server::config(
  $argus_host             = $argus_server::argus_host,
  $centralban_enabled     = $argus_server::centralban_enabled,
  $centralban_dn          = $argus_server::centralban_dn,
  $centralban_host        = $argus_server::centralban_host,
  $pap_poll_interval      = $argus_server::pap_poll_interval,
  $pdp_retention_interval = $argus_server::pdp_retention_interval,
  $admin_password         = $argus_server::admin_password,
  $manage_certificate     = $argus_server::manage_certificate,
  $servicecert            = $argus_server::servicecert,
  $servicekey             = $argus_server::servicekey,
  $servicecert_source     = $argus_server::servicecert_source,
  $servicekey_source      = $argus_server::servicekey_source,
  $configure_bdii         = $argus_server::configure_bdii
) {

  # ARGUS configuration files
  file { '/etc/argus/pap/pap-admin.properties':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template("${module_name}/pap-admin.properties.erb"),
    notify  => Service['argus-pap'],
  }

  file { '/etc/argus/pap/pap_configuration.ini':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template("${module_name}/pap_configuration.ini.erb"),
    notify  => Service['argus-pap'],
  }

  file { '/etc/argus/pdp/pdp.ini':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template("${module_name}/pdp.ini.erb"),
    notify  => Service['argus-pdp'],
  }

  file { '/etc/argus/pepd/pepd.ini':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template("${module_name}/pepd.ini.erb"),
    notify  => Service['argus-pepd'],
  }
  
  if $configure_bdii {
     class { 'argus_server::bdii':}
    }

  if $manage_certificate {
    if $servicecert_source != '' {
      file { $servicecert:
        ensure => 'present',
        owner  => 'root',
        group  => 'root',
        mode   => '0600',
        source => $servicecert_source,
      }
    } else {
      file { $servicecert:
        ensure => 'present',
        owner  => 'root',
        group  => 'root',
        mode   => '0600',
      }
    }
    if $servicekey_source != '' {
      file { $servicekey:
        ensure => 'present',
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
        source => $servicekey_source,
      }
    } else {
      file { $servicekey:
        ensure => 'present',
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
      }
    }
  }
}
