# Copyright (C) 2015, Khulnasoft Inc.
# Khulnasoft repository installation
class khulnasoft::certificates (
  $khulnasoft_repository = 'packages.khulnasoft.com',
  $khulnasoft_version = '4.8',
) {
  file { 'Configure Khulnasoft Certificates config.yml':
    owner   => 'root',
    path    => '/tmp/config.yml',
    group   => 'root',
    mode    => '0640',
    content => template('khulnasoft/khulnasoft_config_yml.erb'),
  }

  file { '/tmp/khulnasoft-certs-tool.sh':
    ensure => file,
    source => "https://${khulnasoft_repository}/${khulnasoft_version}/khulnasoft-certs-tool.sh",
    owner  => 'root',
    group  => 'root',
    mode   => '0740',
  }

  exec { 'Create Khulnasoft Certificates':
    path    => '/usr/bin:/bin',
    command => 'bash /tmp/khulnasoft-certs-tool.sh --all',
    creates => '/tmp/khulnasoft-certificates',
    require => [
      File['/tmp/khulnasoft-certs-tool.sh'],
      File['/tmp/config.yml'],
    ],
  }
}
