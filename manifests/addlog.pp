# Copyright (C) 2015, Khulnasoft Inc.
#Define a log-file to add to ossec
define khulnasoft::addlog(
  $logfile      = undef,
  $logtype      = 'syslog',
  $logcommand   = undef,
  $commandalias = undef,
  $frequency    = undef,
  $target_arg   = 'manager_ossec.conf',
) {
  require khulnasoft::params_manager

  concat::fragment { "ossec.conf_localfile-${logfile}":
    target  => $target_arg,
    content => template('khulnasoft/fragments/_localfile_generation.erb'),
    order   => 21,
  }

}
