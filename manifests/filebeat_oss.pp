# Copyright (C) 2015, Khulnasoft Inc.
# Setup for Filebeat_oss
class khulnasoft::filebeat_oss (
  $filebeat_oss_indexer_ip = '127.0.0.1',
  $filebeat_oss_indexer_port = '9200',
  $indexer_server_ip = "\"${filebeat_oss_indexer_ip}:${filebeat_oss_indexer_port}\"",

  $filebeat_oss_archives = false,
  $filebeat_oss_package = 'filebeat',
  $filebeat_oss_service = 'filebeat',
  $filebeat_oss_elastic_user = 'admin',
  $filebeat_oss_elastic_password = 'admin',
  $filebeat_oss_version = '7.10.2',
  $khulnasoft_app_version = '4.8.0_7.10.2',
  $khulnasoft_extensions_version = '4.8',
  $khulnasoft_filebeat_module = 'khulnasoft-filebeat-0.2.tar.gz',

  $filebeat_fileuser = 'root',
  $filebeat_filegroup = 'root',
  $filebeat_path_certs = '/etc/filebeat/certs',
) {
  include khulnasoft::repo

  if $facts['os']['family'] == 'Debian' {
    Class['khulnasoft::repo'] -> Class['apt::update'] -> Package['filebeat']
  } else {
    Class['khulnasoft::repo'] -> Package['filebeat']
  }

  package { 'filebeat':
    ensure => $filebeat_oss_version,
    name   => $filebeat_oss_package,
  }

  file { '/etc/filebeat/filebeat.yml':
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    notify  => Service['filebeat'], ## Restarts the service
    content => template('khulnasoft/filebeat_oss_yml.erb'),
    require => Package['filebeat'],
  }

  # work around:
  #  Use cmp to compare the content of local and remote file. When they differ than rm the file to get it recreated by the file resource.
  #  Needed since GitHub can only ETAG and result in changes of the mtime everytime.
  # TODO: Include file into the khulnasoft/khulnasoft-puppet project or use file { checksum => '..' } for this instead of the exec construct.
  exec { 'cleanup /etc/filebeat/khulnasoft-template.json':
    command => '/bin/rm -f /etc/filebeat/khulnasoft-template.json',
    onlyif  => '/bin/test -f /etc/filebeat/khulnasoft-template.json',
    unless  => "/bin/curl -s 'https://raw.githubusercontent.com/khulnasoft/khulnasoft/${khulnasoft_extensions_version}/extensions/elasticsearch/7.x/khulnasoft-template.json' | /bin/cmp -s '/etc/filebeat/khulnasoft-template.json'",
  }
  -> file { '/etc/filebeat/khulnasoft-template.json':
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    replace => false,  # only copy content when file not exist
    source  => "https://raw.githubusercontent.com/khulnasoft/khulnasoft/${khulnasoft_extensions_version}/extensions/elasticsearch/7.x/khulnasoft-template.json",
    notify  => Service['filebeat'],
    require => Package['filebeat'],
  }

  archive { "/tmp/${$khulnasoft_filebeat_module}":
    ensure       => present,
    source       => "https://packages.khulnasoft.com/4.x/filebeat/${$khulnasoft_filebeat_module}",
    extract      => true,
    extract_path => '/usr/share/filebeat/module',
    creates      => '/usr/share/filebeat/module/khulnasoft',
    cleanup      => true,
    notify       => Service['filebeat'],
    require      => Package['filebeat'],
  }

  file { '/usr/share/filebeat/module/khulnasoft':
    ensure  => 'directory',
    mode    => '0755',
    require => Package['filebeat'],
  }

  require khulnasoft::certificates

  exec { "ensure full path of ${filebeat_path_certs}":
    path    => '/usr/bin:/bin',
    command => "mkdir -p ${filebeat_path_certs}",
    creates => $filebeat_path_certs,
    require => Package['filebeat'],
  }
  -> file { $filebeat_path_certs:
    ensure => directory,
    owner  => $filebeat_fileuser,
    group  => $filebeat_filegroup,
    mode   => '0500',
  }

  $_certfiles = {
    'server.pem'     => 'filebeat.pem',
    'server-key.pem' => 'filebeat-key.pem',
    'root-ca.pem'    => 'root-ca.pem',
  }
  $_certfiles.each |String $certfile_source, String $certfile_target| {
    file { "${filebeat_path_certs}/${certfile_target}":
      ensure  => file,
      owner   => $filebeat_fileuser,
      group   => $filebeat_filegroup,
      mode    => '0400',
      replace => false,  # only copy content when file not exist
      source  => "/tmp/khulnasoft-certificates/${certfile_source}",
    }
  }

  service { 'filebeat':
    ensure  => running,
    enable  => true,
    name    => $filebeat_oss_service,
    require => Package['filebeat'],
  }
}
