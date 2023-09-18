# Copyright (C) 2015, Khulnasoft Inc.
# Setup for Khulnasoft Dashboard
class khulnasoft::dashboard (
  $dashboard_package = 'khulnasoft-dashboard',
  $dashboard_service = 'khulnasoft-dashboard',
  $dashboard_version = '4.8.0',
  $indexer_server_ip = 'localhost',
  $indexer_server_port = '9200',
  $dashboard_path_certs = '/etc/khulnasoft-dashboard/certs',
  $dashboard_fileuser = 'khulnasoft-dashboard',
  $dashboard_filegroup = 'khulnasoft-dashboard',

  $dashboard_server_port = '443',
  $dashboard_server_host = '0.0.0.0',
  $dashboard_server_hosts = "https://${indexer_server_ip}:${indexer_server_port}",

  # If the keystore is used, the credentials are not managed by the module (TODO).
  # If use_keystore is false, the keystore is deleted, the dashboard use the credentials in the configuration file.
  $use_keystore = true,
  $dashboard_user = 'kibanaserver',
  $dashboard_password = 'kibanaserver',

  $dashboard_khulnasoft_api_credentials = [
    {
      'id'       => 'default',
      'url'      => 'https://localhost',
      'port'     => '55000',
      'user'     => 'khulnasoft-wui',
      'password' => 'khulnasoft-wui',
    },
  ],

  $manage_repos = false, # Change to true when manager is not present.
) {
  if $manage_repos {
    include khulnasoft::repo

    if $::osfamily == 'Debian' {
      Class['khulnasoft::repo'] -> Class['apt::update'] -> Package['khulnasoft-dashboard']
    } else {
      Class['khulnasoft::repo'] -> Package['khulnasoft-dashboard']
    }
  }

  # assign version according to the package manager
  case $facts['os']['family'] {
    'Debian': {
      $dashboard_version_install = "${dashboard_version}-*"
    }
    'Linux', 'RedHat', default: {
      $dashboard_version_install = $dashboard_version
    }
  }

  # install package
  package { 'khulnasoft-dashboard':
    ensure => $dashboard_version_install,
    name   => $dashboard_package,
  }

  require khulnasoft::certificates

  exec { "ensure full path of ${dashboard_path_certs}":
    path    => '/usr/bin:/bin',
    command => "mkdir -p ${dashboard_path_certs}",
    creates => $dashboard_path_certs,
    require => Package['khulnasoft-dashboard'],
  }
  -> file { $dashboard_path_certs:
    ensure => directory,
    owner  => $dashboard_fileuser,
    group  => $dashboard_filegroup,
    mode   => '0500',
  }

  [
    'dashboard.pem',
    'dashboard-key.pem',
    'root-ca.pem',
  ].each |String $certfile| {
    file { "${dashboard_path_certs}/${certfile}":
      ensure  => file,
      owner   => $dashboard_fileuser,
      group   => $dashboard_filegroup,
      mode    => '0400',
      replace => false,  # only copy content when file not exist
      source  => "/tmp/khulnasoft-certificates/${certfile}",
    }
  }

  file { '/etc/khulnasoft-dashboard/opensearch_dashboards.yml':
    content => template('khulnasoft/khulnasoft_dashboard_yml.erb'),
    group   => $dashboard_filegroup,
    mode    => '0640',
    owner   => $dashboard_fileuser,
    require => Package['khulnasoft-dashboard'],
    notify  => Service['khulnasoft-dashboard'],
  }

  file { [ '/usr/share/khulnasoft-dashboard/data/khulnasoft/', '/usr/share/khulnasoft-dashboard/data/khulnasoft/config' ]:
    ensure  => 'directory',
    group   => $dashboard_filegroup,
    mode    => '0755',
    owner   => $dashboard_fileuser,
    require => Package['khulnasoft-dashboard'],
  }
  -> file { '/usr/share/khulnasoft-dashboard/data/khulnasoft/config/khulnasoft.yml':
    content => template('khulnasoft/khulnasoft_yml.erb'),
    group   => $dashboard_filegroup,
    mode    => '0600',
    owner   => $dashboard_fileuser,
    notify  => Service['khulnasoft-dashboard'],
  }

  unless $use_keystore {
    file { '/etc/khulnasoft-dashboard/opensearch_dashboards.keystore':
      ensure  => absent,
      require => Package['khulnasoft-dashboard'],
      before  => Service['khulnasoft-dashboard'],
    }
  }

  service { 'khulnasoft-dashboard':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    name       => $dashboard_service,
  }
}
