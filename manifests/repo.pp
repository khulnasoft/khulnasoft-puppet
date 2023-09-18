# Copyright (C) 2015, Khulnasoft Inc.
# Khulnasoft repository installation
class khulnasoft::repo (
) {

  case $::osfamily {
    'Debian' : {
      if $::lsbdistcodename =~ /(jessie|wheezy|stretch|precise|trusty|vivid|wily|xenial|yakketi|groovy)/
      and ! defined(Package['apt-transport-https']) {
        ensure_packages(['apt-transport-https'], {'ensure' => 'present'})
      }
      # apt-key added by issue #34
      apt::key { 'khulnasoft':
        id     => '0DCFCA5547B19D2A6099506096B3EE5F29111145',
        source => 'https://packages.khulnasoft.com/key/GPG-KEY-KHULNASOFT',
        server => 'pgp.mit.edu'
      }
      case $::lsbdistcodename {
        /(jessie|wheezy|stretch|buster|bullseye|bookworm|sid|precise|trusty|vivid|wily|xenial|yakketi|bionic|focal|groovy|jammy)/: {

          apt::source { 'khulnasoft':
            ensure   => present,
            comment  => 'This is the KHULNASOFT Ubuntu repository',
            location => 'https://packages.khulnasoft.com/4.x/apt',
            release  => 'stable',
            repos    => 'main',
            include  => {
              'src' => false,
              'deb' => true,
            },
          }
        }
        default: { fail('This ossec module has not been tested on your distribution (or lsb package not installed)') }
      }
    }
    'Linux', 'RedHat', 'Suse' : {
        case $::os[name] {
          /^(CentOS|RedHat|OracleLinux|Fedora|Amazon|AlmaLinux|Rocky|SLES)$/: {

            if ( $::operatingsystemrelease =~ /^5.*/ ) {
              $baseurl  = 'https://packages.khulnasoft.com/4.x/yum/5/'
              $gpgkey   = 'http://packages.khulnasoft.com/key/GPG-KEY-KHULNASOFT'
            } else {
              $baseurl  = 'https://packages.khulnasoft.com/4.x/yum/'
              $gpgkey   = 'https://packages.khulnasoft.com/key/GPG-KEY-KHULNASOFT'
            }
          }
          default: { fail('This ossec module has not been tested on your distribution.') }
        }
        # Set up OSSEC repo
        case $::os[name] {
          /^(CentOS|RedHat|OracleLinux|Fedora|Amazon|AlmaLinux)$/: {
            yumrepo { 'khulnasoft':
              descr    => 'KHULNASOFT OSSEC Repository - www.khulnasoft.com',
              enabled  => true,
              gpgcheck => 1,
              gpgkey   => $gpgkey,
              baseurl  => $baseurl
            }
          }
          /^(SLES)$/: {
            zypprepo { 'khulnasoft':
              ensure        => present,
              name          => 'KHULNASOFT OSSEC Repository - www.khulnasoft.com',
              enabled       => 1,
              gpgcheck      => 0,
              repo_gpgcheck => 0,
              pkg_gpgcheck  => 0,
              gpgkey        => $gpgkey,
              baseurl       => $baseurl
            }
          }
        }
    }
  }
}
