# Copyright (C) 2015, Khulnasoft Inc.
# Setup for Khulnasoft Indexer
class khulnasoft::indexer (
  # opensearch.yml configuration
  $indexer_network_host = '0.0.0.0',
  $indexer_cluster_name = 'khulnasoft-cluster',
  $indexer_node_name = 'node-1',
  $indexer_node_max_local_storage_nodes = '1',
  $indexer_service = 'khulnasoft-indexer',
  $indexer_package = 'khulnasoft-indexer',
  $indexer_version = '4.8.0-1',
  $indexer_fileuser = 'khulnasoft-indexer',
  $indexer_filegroup = 'khulnasoft-indexer',

  $indexer_path_data = '/var/lib/khulnasoft-indexer',
  $indexer_path_logs = '/var/log/khulnasoft-indexer',
  $indexer_path_certs = '/etc/khulnasoft-indexer/certs',
  $indexer_security_init_lockfile = '/var/tmp/indexer-security-init.lock',
  $full_indexer_reinstall = false, # Change to true when whant a full reinstall of Khulnasoft indexer

  $indexer_ip = 'localhost',
  $indexer_port = '9200',
  $indexer_discovery_hosts = [], # Empty array for single-node configuration
  $indexer_cluster_initial_master_nodes = ['node-1'],

  $manage_repos = false, # Change to true when manager is not present.

  # JVM options
  $jvm_options_memory = '1g',
) {
  if $manage_repos {
    include khulnasoft::repo
    if $facts['os']['family'] == 'Debian' {
      Class['khulnasoft::repo'] -> Class['apt::update'] -> Package['khulnasoft-indexer']
    } else {
      Class['khulnasoft::repo'] -> Package['khulnasoft-indexer']
    }
  }

  # install package
  package { 'khulnasoft-indexer':
    ensure => $indexer_version,
    name   => $indexer_package,
  }

  require khulnasoft::certificates

  exec { "ensure full path of ${indexer_path_certs}":
    path    => '/usr/bin:/bin',
    command => "mkdir -p ${indexer_path_certs}",
    creates => $indexer_path_certs,
    require => Package['khulnasoft-indexer'],
  }
  -> file { $indexer_path_certs:
    ensure => directory,
    owner  => $indexer_fileuser,
    group  => $indexer_filegroup,
    mode   => '0500',
  }

  [
    'indexer.pem',
    'indexer-key.pem',
    'root-ca.pem',
    'admin.pem',
    'admin-key.pem',
  ].each |String $certfile| {
    file { "${indexer_path_certs}/${certfile}":
      ensure  => file,
      owner   => $indexer_fileuser,
      group   => $indexer_filegroup,
      mode    => '0400',
      replace => false,  # only copy content when file not exist
      source  => "/tmp/khulnasoft-certificates/${certfile}",
    }
  }

  file { 'configuration file':
    path    => '/etc/khulnasoft-indexer/opensearch.yml',
    content => template('khulnasoft/khulnasoft_indexer_yml.erb'),
    group   => $indexer_filegroup,
    mode    => '0660',
    owner   => $indexer_fileuser,
    require => Package['khulnasoft-indexer'],
    notify  => Service['khulnasoft-indexer'],
  }

  file_line { 'Insert line initial size of total heap space':
    path    => '/etc/khulnasoft-indexer/jvm.options',
    line    => "-Xms${jvm_options_memory}",
    match   => '^-Xms',
    require => Package['khulnasoft-indexer'],
    notify  => Service['khulnasoft-indexer'],
  }

  file_line { 'Insert line maximum size of total heap space':
    path    => '/etc/khulnasoft-indexer/jvm.options',
    line    => "-Xmx${jvm_options_memory}",
    match   => '^-Xmx',
    require => Package['khulnasoft-indexer'],
    notify  => Service['khulnasoft-indexer'],
  }

  service { 'khulnasoft-indexer':
    ensure  => running,
    enable  => true,
    name    => $indexer_service,
    require => Package['khulnasoft-indexer'],
  }

  file_line { "Insert line limits nofile for ${indexer_fileuser}":
    path   => '/etc/security/limits.conf',
    line   => "${indexer_fileuser} - nofile  65535",
    match  => "^${indexer_fileuser} - nofile\s",
    notify => Service['khulnasoft-indexer'],
  }
  file_line { "Insert line limits memlock for ${indexer_fileuser}":
    path   => '/etc/security/limits.conf',
    line   => "${indexer_fileuser} - memlock unlimited",
    match  => "^${indexer_fileuser} - memlock\s",
    notify => Service['khulnasoft-indexer'],
  }

  # TODO: this should be done by the package itself and not by puppet at all
  [
    '/etc/khulnasoft-indexer',
    '/usr/share/khulnasoft-indexer',
    '/var/lib/khulnasoft-indexer',
  ].each |String $file| {
    exec { "set recusive ownership of ${file}":
      path        => '/usr/bin:/bin',
      command     => "chown ${indexer_fileuser}:${indexer_filegroup} -R ${file}",
      refreshonly => true,  # only run when package is installed or updated
      subscribe   => Package['khulnasoft-indexer'],
      notify      => Service['khulnasoft-indexer'],
    }
  }

  if $full_indexer_reinstall {
    file { $indexer_security_init_lockfile:
      ensure  => absent,
      require => Package['khulnasoft-indexer'],
      before  => Exec['Initialize the Opensearch security index in Khulnasoft indexer'],
    }
  }

  exec { 'Initialize the Opensearch security index in Khulnasoft indexer':
    path    => ['/usr/bin', '/bin', '/usr/sbin'],
    command => "/usr/share/khulnasoft-indexer/bin/indexer-security-init.sh && touch ${indexer_security_init_lockfile}",
    creates => $indexer_security_init_lockfile,
    require => Service['khulnasoft-indexer'],
  }
}
