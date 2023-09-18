# Copyright (C) 2015, Khulnasoft Inc.
# Define an email alert
define khulnasoft::email_alert(
  $alert_email,
  $alert_group    = false,
  $target_arg     = 'manager_ossec.conf',
  $level          = false,
  $event_location = false,
  $format         = false,
  $rule_id        = false,
  $do_not_delay   = false,
  $do_not_group   = false
) {
  require khulnasoft::params_manager

  concat::fragment { $name:
    target  => $target_arg,
    order   => 66,
    content => template('khulnasoft/fragments/_email_alert.erb'),
  }
}
