# Copyright (C) 2015, Khulnasoft Inc.

# Puppet class that installs and manages the Khulnasoft agent
class khulnasoft::agent (

  # Versioning and package names

  $agent_package_version             = $khulnasoft::params_agent::agent_package_version,
  $agent_package_revision            = $khulnasoft::params_agent::agent_package_revision,
  $agent_package_name                = $khulnasoft::params_agent::agent_package_name,
  $agent_service_name                = $khulnasoft::params_agent::agent_service_name,
  $agent_service_ensure              = $khulnasoft::params_agent::agent_service_ensure,
  $agent_msi_download_location       = $khulnasoft::params_agent::agent_msi_download_location,

  # Manage repository

  $manage_repo                       = $khulnasoft::params_agent::manage_repo,

  # Authd registration options
  $manage_client_keys                = $khulnasoft::params_agent::manage_client_keys,
  $agent_name                        = $khulnasoft::params_agent::agent_name,
  $agent_group                       = $khulnasoft::params_agent::agent_group,
  $agent_address                     = $khulnasoft::params_agent::agent_address,
  $khulnasoft_agent_cert                  = $khulnasoft::params_agent::khulnasoft_agent_cert,
  $khulnasoft_agent_key                   = $khulnasoft::params_agent::khulnasoft_agent_key,
  $khulnasoft_agent_cert_path             = $khulnasoft::params_agent::khulnasoft_agent_cert_path,
  $khulnasoft_agent_key_path              = $khulnasoft::params_agent::khulnasoft_agent_key_path,
  $agent_auth_password               = $khulnasoft::params_agent::agent_auth_password,
  $khulnasoft_manager_root_ca_pem         = $khulnasoft::params_agent::khulnasoft_manager_root_ca_pem,
  $khulnasoft_manager_root_ca_pem_path    = $khulnasoft::params_agent::khulnasoft_manager_root_ca_pem_path,

  ## ossec.conf generation parameters
  # Generation variables
  $configure_rootcheck               = $khulnasoft::params_agent::configure_rootcheck,
  $configure_wodle_openscap          = $khulnasoft::params_agent::configure_wodle_openscap,
  $configure_wodle_cis_cat           = $khulnasoft::params_agent::configure_wodle_cis_cat,
  $configure_wodle_osquery           = $khulnasoft::params_agent::configure_wodle_osquery,
  $configure_wodle_syscollector      = $khulnasoft::params_agent::configure_wodle_syscollector,
  $configure_wodle_docker_listener   = $khulnasoft::params_agent::configure_wodle_docker_listener,
  $configure_sca                     = $khulnasoft::params_agent::configure_sca,
  $configure_syscheck                = $khulnasoft::params_agent::configure_syscheck,
  $configure_localfile               = $khulnasoft::params_agent::configure_localfile,
  $configure_active_response         = $khulnasoft::params_agent::configure_active_response,
  $configure_labels                  = $khulnasoft::params_agent::configure_labels,

  # Templates paths
  $ossec_conf_template                  = $khulnasoft::params_agent::ossec_conf_template,
  $ossec_rootcheck_template             = $khulnasoft::params_agent::ossec_rootcheck_template,
  $ossec_wodle_openscap_template        = $khulnasoft::params_agent::ossec_wodle_openscap_template,
  $ossec_wodle_cis_cat_template         = $khulnasoft::params_agent::ossec_wodle_cis_cat_template,
  $ossec_wodle_osquery_template         = $khulnasoft::params_agent::ossec_wodle_osquery_template,
  $ossec_wodle_syscollector_template    = $khulnasoft::params_agent::ossec_wodle_syscollector_template,
  $ossec_wodle_docker_listener_template = $khulnasoft::params_agent::ossec_wodle_docker_listener_template,
  $ossec_sca_template                   = $khulnasoft::params_agent::ossec_sca_template,
  $ossec_syscheck_template              = $khulnasoft::params_agent::ossec_syscheck_template,
  $ossec_localfile_template             = $khulnasoft::params_agent::ossec_localfile_template,
  $ossec_auth                           = $khulnasoft::params_agent::ossec_auth,
  $ossec_cluster                        = $khulnasoft::params_agent::ossec_cluster,
  $ossec_active_response_template       = $khulnasoft::params_agent::ossec_active_response_template,
  $ossec_labels_template                = $khulnasoft::params_agent::ossec_labels_template,

  # Server configuration

  $khulnasoft_register_endpoint           = $khulnasoft::params_agent::khulnasoft_register_endpoint,
  $khulnasoft_reporting_endpoint          = $khulnasoft::params_agent::khulnasoft_reporting_endpoint,
  $ossec_port                        = $khulnasoft::params_agent::ossec_port,
  $ossec_protocol                    = $khulnasoft::params_agent::ossec_protocol,
  $khulnasoft_max_retries                 = $khulnasoft::params_agent::khulnasoft_max_retries,
  $khulnasoft_retry_interval              = $khulnasoft::params_agent::khulnasoft_retry_interval,
  $ossec_config_ubuntu_profiles      = $khulnasoft::params_agent::ossec_config_ubuntu_profiles,
  $ossec_config_centos_profiles      = $khulnasoft::params_agent::ossec_config_centos_profiles,
  $ossec_notify_time                 = $khulnasoft::params_agent::ossec_notify_time,
  $ossec_time_reconnect              = $khulnasoft::params_agent::ossec_time_reconnect,
  $ossec_auto_restart                = $khulnasoft::params_agent::ossec_auto_restart,
  $ossec_crypto_method               = $khulnasoft::params_agent::ossec_crypto_method,
  $client_buffer_disabled            = $khulnasoft::params_agent::client_buffer_disabled,
  $client_buffer_queue_size          = $khulnasoft::params_agent::client_buffer_queue_size,
  $client_buffer_events_per_second   = $khulnasoft::params_agent::client_buffer_events_per_second,

  # Auto enrollment configuration

  $khulnasoft_enrollment_enabled          = $khulnasoft::params_agent::khulnasoft_enrollment_enabled,
  $khulnasoft_enrollment_manager_address  = $khulnasoft::params_agent::khulnasoft_enrollment_manager_address,
  $khulnasoft_enrollment_port             = $khulnasoft::params_agent::khulnasoft_enrollment_port,
  $khulnasoft_enrollment_agent_name       = $khulnasoft::params_agent::khulnasoft_enrollment_agent_name,
  $khulnasoft_enrollment_groups           = $khulnasoft::params_agent::khulnasoft_enrollment_groups,
  $khulnasoft_enrollment_agent_address    = $khulnasoft::params_agent::khulnasoft_enrollment_agent_address,
  $khulnasoft_enrollment_ssl_cipher       = $khulnasoft::params_agent::khulnasoft_enrollment_ssl_cipher,
  $khulnasoft_enrollment_server_ca_path   = $khulnasoft::params_agent::khulnasoft_enrollment_server_ca_path,
  $khulnasoft_enrollment_agent_cert_path  = $khulnasoft::params_agent::khulnasoft_enrollment_agent_cert_path,
  $khulnasoft_enrollment_agent_key_path   = $khulnasoft::params_agent::khulnasoft_enrollment_agent_key_path,
  $khulnasoft_enrollment_auth_pass        = $khulnasoft::params_agent::khulnasoft_enrollment_auth_pass,
  $khulnasoft_enrollment_auth_pass_path   = $khulnasoft::params_agent::khulnasoft_enrollment_auth_pass_path,
  $khulnasoft_enrollment_auto_method      = $khulnasoft::params_agent::khulnasoft_enrollment_auto_method,
  $khulnasoft_delay_after_enrollment      = $khulnasoft::params_agent::khulnasoft_delay_after_enrollment,
  $khulnasoft_enrollment_use_source_ip    = $khulnasoft::params_agent::khulnasoft_enrollment_use_source_ip,


  # Rootcheck
  $ossec_rootcheck_disabled           = $khulnasoft::params_agent::ossec_rootcheck_disabled,
  $ossec_rootcheck_check_files        = $khulnasoft::params_agent::ossec_rootcheck_check_files,
  $ossec_rootcheck_check_trojans      = $khulnasoft::params_agent::ossec_rootcheck_check_trojans,
  $ossec_rootcheck_check_dev          = $khulnasoft::params_agent::ossec_rootcheck_check_dev,
  $ossec_rootcheck_check_sys          = $khulnasoft::params_agent::ossec_rootcheck_check_sys,
  $ossec_rootcheck_check_pids         = $khulnasoft::params_agent::ossec_rootcheck_check_pids,
  $ossec_rootcheck_check_ports        = $khulnasoft::params_agent::ossec_rootcheck_check_ports,
  $ossec_rootcheck_check_if           = $khulnasoft::params_agent::ossec_rootcheck_check_if,
  $ossec_rootcheck_frequency          = $khulnasoft::params_agent::ossec_rootcheck_frequency,
  $ossec_rootcheck_ignore_list        = $khulnasoft::params_agent::ossec_rootcheck_ignore_list,
  $ossec_rootcheck_ignore_sregex_list = $khulnasoft::params_agent::ossec_rootcheck_ignore_sregex_list,
  $ossec_rootcheck_rootkit_files      = $khulnasoft::params_agent::ossec_rootcheck_rootkit_files,
  $ossec_rootcheck_rootkit_trojans    = $khulnasoft::params_agent::ossec_rootcheck_rootkit_trojans,
  $ossec_rootcheck_skip_nfs           = $khulnasoft::params_agent::ossec_rootcheck_skip_nfs,
  $ossec_rootcheck_system_audit      = $khulnasoft::params_agent::ossec_rootcheck_system_audit,


  # rootcheck windows
  $ossec_rootcheck_windows_disabled        = $khulnasoft::params_agent::ossec_rootcheck_windows_disabled,
  $ossec_rootcheck_windows_windows_apps    = $khulnasoft::params_agent::ossec_rootcheck_windows_windows_apps,
  $ossec_rootcheck_windows_windows_malware = $khulnasoft::params_agent::ossec_rootcheck_windows_windows_malware,

  # SCA

  ## Amazon
  $sca_amazon_enabled = $khulnasoft::params_agent::sca_amazon_enabled,
  $sca_amazon_scan_on_start = $khulnasoft::params_agent::sca_amazon_scan_on_start,
  $sca_amazon_interval = $khulnasoft::params_agent::sca_amazon_interval,
  $sca_amazon_skip_nfs = $khulnasoft::params_agent::sca_amazon_skip_nfs,
  $sca_amazon_policies = $khulnasoft::params_agent::sca_amazon_policies,

  ## RHEL
  $sca_rhel_enabled = $khulnasoft::params_agent::sca_rhel_enabled,
  $sca_rhel_scan_on_start = $khulnasoft::params_agent::sca_rhel_scan_on_start,
  $sca_rhel_interval = $khulnasoft::params_agent::sca_rhel_interval,
  $sca_rhel_skip_nfs = $khulnasoft::params_agent::sca_rhel_skip_nfs,
  $sca_rhel_policies = $khulnasoft::params_agent::sca_rhel_policies,

  ## <Linux else>
  $sca_else_enabled = $khulnasoft::params_agent::sca_else_enabled,
  $sca_else_scan_on_start = $khulnasoft::params_agent::sca_else_scan_on_start,
  $sca_else_interval = $khulnasoft::params_agent::sca_else_interval,
  $sca_else_skip_nfs = $khulnasoft::params_agent::sca_else_skip_nfs,
  $sca_else_policies = $khulnasoft::params_agent::sca_else_policies,

  $sca_windows_enabled = $khulnasoft::params_agent::sca_windows_enabled,
  $sca_windows_scan_on_start = $khulnasoft::params_agent::sca_windows_scan_on_start,
  $sca_windows_interval = $khulnasoft::params_agent::sca_windows_interval,
  $sca_windows_skip_nfs = $khulnasoft::params_agent::sca_windows_skip_nfs,
  $sca_windows_policies = $khulnasoft::params_agent::sca_windows_policies,

  ## Wodles

  # Openscap
  $wodle_openscap_disabled           = $khulnasoft::params_agent::wodle_openscap_disabled,
  $wodle_openscap_timeout            = $khulnasoft::params_agent::wodle_openscap_timeout,
  $wodle_openscap_interval           = $khulnasoft::params_agent::wodle_openscap_interval,
  $wodle_openscap_scan_on_start      = $khulnasoft::params_agent::wodle_openscap_scan_on_start,

  # Ciscat
  $wodle_ciscat_disabled             = $khulnasoft::params_agent::wodle_ciscat_disabled,
  $wodle_ciscat_timeout              = $khulnasoft::params_agent::wodle_ciscat_timeout,
  $wodle_ciscat_interval             = $khulnasoft::params_agent::wodle_ciscat_interval,
  $wodle_ciscat_scan_on_start        = $khulnasoft::params_agent::wodle_ciscat_scan_on_start,
  $wodle_ciscat_java_path            = $khulnasoft::params_agent::wodle_ciscat_java_path,
  $wodle_ciscat_ciscat_path          = $khulnasoft::params_agent::wodle_ciscat_ciscat_path,

  #Osquery

  $wodle_osquery_disabled            = $khulnasoft::params_agent::wodle_osquery_disabled,
  $wodle_osquery_run_daemon          = $khulnasoft::params_agent::wodle_osquery_run_daemon,
  $wodle_osquery_bin_path            = $khulnasoft::params_agent::wodle_osquery_bin_path,
  $wodle_osquery_log_path            = $khulnasoft::params_agent::wodle_osquery_log_path,
  $wodle_osquery_config_path         = $khulnasoft::params_agent::wodle_osquery_config_path,
  $wodle_osquery_add_labels          = $khulnasoft::params_agent::wodle_osquery_add_labels,

  # Syscollector

  $wodle_syscollector_disabled       = $khulnasoft::params_agent::wodle_syscollector_disabled,
  $wodle_syscollector_interval       = $khulnasoft::params_agent::wodle_syscollector_interval,
  $wodle_syscollector_scan_on_start  = $khulnasoft::params_agent::wodle_syscollector_scan_on_start,
  $wodle_syscollector_hardware       = $khulnasoft::params_agent::wodle_syscollector_hardware,
  $wodle_syscollector_os             = $khulnasoft::params_agent::wodle_syscollector_os,
  $wodle_syscollector_network        = $khulnasoft::params_agent::wodle_syscollector_network,
  $wodle_syscollector_packages       = $khulnasoft::params_agent::wodle_syscollector_packages,
  $wodle_syscollector_ports          = $khulnasoft::params_agent::wodle_syscollector_ports,
  $wodle_syscollector_processes      = $khulnasoft::params_agent::wodle_syscollector_processes,
  $wodle_syscollector_hotfixes       = $khulnasoft::params_agent::wodle_syscollector_hotfixes,

  # Docker-listener
  $wodle_docker_listener_disabled    = $khulnasoft::params_agent::wodle_docker_listener_disabled,

  # Localfile
  $ossec_local_files                 = $khulnasoft::params_agent::default_local_files,

  # Syscheck
  $ossec_syscheck_disabled           = $khulnasoft::params_agent::ossec_syscheck_disabled,
  $ossec_syscheck_frequency          = $khulnasoft::params_agent::ossec_syscheck_frequency,
  $ossec_syscheck_scan_on_start      = $khulnasoft::params_agent::ossec_syscheck_scan_on_start,
  $ossec_syscheck_auto_ignore        = $khulnasoft::params_agent::ossec_syscheck_auto_ignore,
  $ossec_syscheck_directories_1      = $khulnasoft::params_agent::ossec_syscheck_directories_1,
  $ossec_syscheck_directories_2      = $khulnasoft::params_agent::ossec_syscheck_directories_2,

  $ossec_syscheck_report_changes_directories_1            = $khulnasoft::params_agent::ossec_syscheck_report_changes_directories_1,
  $ossec_syscheck_whodata_directories_1            = $khulnasoft::params_agent::ossec_syscheck_whodata_directories_1,
  $ossec_syscheck_realtime_directories_1           = $khulnasoft::params_agent::ossec_syscheck_realtime_directories_1,
  $ossec_syscheck_report_changes_directories_2         = $khulnasoft::params_agent::ossec_syscheck_report_changes_directories_2,
  $ossec_syscheck_whodata_directories_2            = $khulnasoft::params_agent::ossec_syscheck_whodata_directories_2,
  $ossec_syscheck_realtime_directories_2           = $khulnasoft::params_agent::ossec_syscheck_realtime_directories_2,
  $ossec_syscheck_ignore_list        = $khulnasoft::params_agent::ossec_syscheck_ignore_list,
  $ossec_syscheck_ignore_type_1      = $khulnasoft::params_agent::ossec_syscheck_ignore_type_1,
  $ossec_syscheck_ignore_type_2      = $khulnasoft::params_agent::ossec_syscheck_ignore_type_2,
  $ossec_syscheck_max_eps                      = $khulnasoft::params_agent::ossec_syscheck_max_eps,
  $ossec_syscheck_process_priority             = $khulnasoft::params_agent::ossec_syscheck_process_priority,
  $ossec_syscheck_synchronization_enabled      = $khulnasoft::params_agent::ossec_syscheck_synchronization_enabled,
  $ossec_syscheck_synchronization_interval     = $khulnasoft::params_agent::ossec_syscheck_synchronization_interval,
  $ossec_syscheck_synchronization_max_eps      = $khulnasoft::params_agent::ossec_syscheck_synchronization_max_eps,
  $ossec_syscheck_synchronization_max_interval = $khulnasoft::params_agent::ossec_syscheck_synchronization_max_interval,
  $ossec_syscheck_nodiff             = $khulnasoft::params_agent::ossec_syscheck_nodiff,
  $ossec_syscheck_skip_nfs           = $khulnasoft::params_agent::ossec_syscheck_skip_nfs,
  $ossec_syscheck_windows_audit_interval      = $khulnasoft::params_agent::windows_audit_interval,

  # Audit
  $audit_manage_rules                = $khulnasoft::params_agent::audit_manage_rules,
  $audit_buffer_bytes                = $khulnasoft::params_agent::audit_buffer_bytes,
  $audit_backlog_wait_time           = $khulnasoft::params_agent::audit_backlog_wait_time,
  $audit_rules                       = $khulnasoft::params_agent::audit_rules,

  # active-response
  $ossec_active_response_disabled             =  $khulnasoft::params_agent::active_response_disabled,
  $ossec_active_response_linux_ca_store       =  $khulnasoft::params_agent::active_response_linux_ca_store,
  $ossec_active_response_ca_verification      =  $khulnasoft::params_agent::active_response_ca_verification,
  $ossec_active_response_repeated_offenders   =  $khulnasoft::params_agent::active_response_repeated_offenders,

  # Agent Labels
  $ossec_labels                      = $khulnasoft::params_agent::ossec_labels,

  ## Selinux

  $selinux                           = $khulnasoft::params_agent::selinux,
  $manage_firewall                   = $khulnasoft::params_agent::manage_firewall,

  ## Windows

  $download_path                     = $khulnasoft::params_agent::download_path,

  # Logging
  $logging_log_format                = $khulnasoft::params_agent::logging_log_format,
) inherits khulnasoft::params_agent {
  # validate_bool(
  #   $ossec_active_response, $ossec_rootcheck,
  #   $selinux, $manage_repo,
  # )
  # This allows arrays of integers, sadly
  # (commented due to stdlib version requirement)
  validate_legacy(String, 'validate_string', $agent_package_name)
  validate_legacy(String, 'validate_string', $agent_service_name)

  if (( $ossec_syscheck_whodata_directories_1 == 'yes' ) or ( $ossec_syscheck_whodata_directories_2 == 'yes' )) {
    class { 'khulnasoft::audit':
      audit_manage_rules      => $audit_manage_rules,
      audit_backlog_wait_time => $audit_backlog_wait_time,
      audit_buffer_bytes      => $audit_buffer_bytes,
      audit_rules             => $audit_rules,
    }
  }


  if $manage_client_keys == 'yes' {
    if $khulnasoft_register_endpoint == undef {
      fail('The $khulnasoft_register_endpoint parameter is needed in order to register the Agent.')
    }
  }

  # Package installation
  case $::kernel {
    'Linux': {
      if $manage_repo {
        class { 'khulnasoft::repo': }
        if $::osfamily == 'Debian' {
          Class['khulnasoft::repo'] -> Class['apt::update'] -> Package[$agent_package_name]
        } else {
          Class['khulnasoft::repo'] -> Package[$agent_package_name]
        }
      }
      package { $agent_package_name:
        ensure => "${agent_package_version}-${agent_package_revision}", # lint:ignore:security_package_pinned_version
      }
    }
    'windows': {
      file { $download_path:
        ensure => directory,
      }

      -> file { 'khulnasoft-agent':
        path               => "${download_path}\\khulnasoft-agent-${agent_package_version}-${agent_package_revision}.msi",
        group              => 'Administrators',
        mode               => '0774',
        source             => "${agent_msi_download_location}/khulnasoft-agent-${agent_package_version}-${agent_package_revision}.msi",
        source_permissions => ignore
      }

      # We dont need to pin the package version on Windows since we install if from the right MSI.
      -> package { $agent_package_name:
        ensure          => "${agent_package_version}",
        provider        => 'windows',
        source          => "${download_path}\\khulnasoft-agent-${agent_package_version}-${agent_package_revision}.msi",
        install_options => [
          '/q',
          "KHULNASOFT_MANAGER=${khulnasoft_reporting_endpoint}",
          "KHULNASOFT_PROTOCOL=${ossec_protocol}",
        ],
      }
    }
    default: { fail('OS not supported') }
  }

  case $::kernel {
  'Linux': {
    ## ossec.conf generation concats
    case $::operatingsystem {
      'RedHat', 'OracleLinux', 'Suse':{
        $apply_template_os = 'rhel'
        if ( $::operatingsystemrelease =~ /^9.*/ ){
          $rhel_version = '9'
        }elsif ( $::operatingsystemrelease =~ /^8.*/ ){
          $rhel_version = '8'
        }elsif ( $::operatingsystemrelease =~ /^7.*/ ){
          $rhel_version = '7'
        }elsif ( $::operatingsystemrelease =~ /^6.*/ ){
          $rhel_version = '6'
        }elsif ( $::operatingsystemrelease =~ /^5.*/ ){
          $rhel_version = '5'
        }else{
          fail('This ossec module has not been tested on your distribution')
        }
      }'Debian', 'debian', 'Ubuntu', 'ubuntu':{
        $apply_template_os = 'debian'
        if ( $::lsbdistcodename == 'wheezy') or ($::lsbdistcodename == 'jessie'){
          $debian_additional_templates = 'yes'
        }
      }'Amazon':{
        $apply_template_os = 'amazon'
      }'CentOS','Centos','centos','AlmaLinux','Rocky':{
        $apply_template_os = 'centos'
      }'SLES':{
        $apply_template_os = 'suse'
      }
      default: { fail('OS not supported') }
    }
  }'windows': {
      $apply_template_os = 'windows'
    }
    default: { fail('OS not supported') }
  }


  concat { 'agent_ossec.conf':
    path    => $khulnasoft::params_agent::config_file,
    owner   => $khulnasoft::params_agent::config_owner,
    group   => $khulnasoft::params_agent::config_group,
    mode    => $khulnasoft::params_agent::config_mode,
    before  => Service[$agent_service_name],
    require => Package[$agent_package_name],
    notify  => Service[$agent_service_name],
  }

  concat::fragment {
    'ossec.conf_header':
      target  => 'agent_ossec.conf',
      order   => 00,
      before  => Service[$agent_service_name],
      content => "<ossec_config>\n";
    'ossec.conf_agent':
      target  => 'agent_ossec.conf',
      order   => 10,
      before  => Service[$agent_service_name],
      content => template($ossec_conf_template);
  }

  if ($configure_rootcheck == true) {
    concat::fragment {
      'ossec.conf_rootcheck':
        target  => 'agent_ossec.conf',
        order   => 15,
        before  => Service[$agent_service_name],
        content => template($ossec_rootcheck_template);
    }
  }
  if ($configure_wodle_openscap == true) {
    concat::fragment {
      'ossec.conf_openscap':
        target  => 'agent_ossec.conf',
        order   => 16,
        before  => Service[$agent_service_name],
        content => template($ossec_wodle_openscap_template);
    }
  }
  if ($configure_wodle_cis_cat == true) {
    concat::fragment {
      'ossec.conf_cis_cat':
        target  => 'agent_ossec.conf',
        order   => 17,
        before  => Service[$agent_service_name],
        content => template($ossec_wodle_cis_cat_template);
    }
  }
  if ($configure_wodle_osquery == true) {
    concat::fragment {
      'ossec.conf_osquery':
        target  => 'agent_ossec.conf',
        order   => 18,
        before  => Service[$agent_service_name],
        content => template($ossec_wodle_osquery_template);
    }
  }
  if ($configure_wodle_syscollector == true) {
    concat::fragment {
      'ossec.conf_syscollector':
        target  => 'agent_ossec.conf',
        order   => 19,
        before  => Service[$agent_service_name],
        content => template($ossec_wodle_syscollector_template);
    }
  }
  if ($configure_wodle_docker_listener == true) {
    concat::fragment {
      'ossec.conf_docker_listener':
        target  => 'agent_ossec.conf',
        order   => 20,
        before  => Service[$agent_service_name],
        content => template($ossec_wodle_docker_listener_template);
    }
  }
  if ($configure_sca == true) {
    concat::fragment {
      'ossec.conf_sca':
        target  => 'agent_ossec.conf',
        order   => 25,
        before  => Service[$agent_service_name],
        content => template($ossec_sca_template);
    }
  }
  if ($configure_syscheck == true) {
    concat::fragment {
      'ossec.conf_syscheck':
        target  => 'agent_ossec.conf',
        order   => 30,
        before  => Service[$agent_service_name],
        content => template($ossec_syscheck_template);
    }
  }
  if ($configure_localfile == true) {
    concat::fragment {
      'ossec.conf_localfile':
        target  => 'agent_ossec.conf',
        order   => 35,
        before  => Service[$agent_service_name],
        content => template($ossec_localfile_template);
    }
  }
  if ($configure_active_response == true) {
    khulnasoft::activeresponse { 'active-response configuration':
      active_response_disabled           =>  $ossec_active_response_disabled,
      active_response_linux_ca_store     =>  $ossec_active_response_linux_ca_store,
      active_response_ca_verification    =>  $ossec_active_response_ca_verification,
      active_response_repeated_offenders =>  $ossec_active_response_repeated_offenders,
      order_arg                          => 40,
      before_arg                         => Service[$agent_service_name],
      target_arg                         => 'agent_ossec.conf'
    }
  }

  if ($configure_labels == true){
    concat::fragment {
        'ossec.conf_labels':
        target  => 'agent_ossec.conf',
        order   => 45,
        before  => Service[$agent_service_name],
        content => template($ossec_labels_template);
    }
  }

  concat::fragment {
    'ossec.conf_footer':
      target  => 'agent_ossec.conf',
      order   => 99,
      before  => Service[$agent_service_name],
      content => '</ossec_config>';
  }

  # Agent registration and service setup
  if ($manage_client_keys == 'yes') {
    if $agent_name {
      validate_legacy(String, 'validate_string', $agent_name)
      $agent_auth_option_name = "-A \"${agent_name}\""
    } else {
      $agent_auth_option_name = ''
    }

    if $agent_group {
      validate_legacy(String, 'validate_string', $agent_group)
      $agent_auth_option_group = "-G \"${agent_group}\""
    } else {
      $agent_auth_option_group = ''
    }

    if $agent_auth_password {
      $agent_auth_option_password = "-P \"${agent_auth_password}\""
    } else {
      $agent_auth_option_password = ''
    }

    if $agent_address {
      $agent_auth_option_address = "-I \"${agent_address}\""
    } else {
      $agent_auth_option_address = ''
    }

    case $::kernel {
      'Linux': {
        file { $::khulnasoft::params_agent::keys_file:
          owner => $khulnasoft::params_agent::keys_owner,
          group => $khulnasoft::params_agent::keys_group,
          mode  => $khulnasoft::params_agent::keys_mode,
        }

        $agent_auth_executable = '/var/ossec/bin/agent-auth'
        $agent_auth_base_command = "${agent_auth_executable} -m ${khulnasoft_register_endpoint}"

        # https://documentation.khulnasoft.com/4.0/user-manual/registering/manager-verification/manager-verification-registration.html
        if $khulnasoft_manager_root_ca_pem != undef {
          validate_legacy(String, 'validate_string', $khulnasoft_manager_root_ca_pem)
          file { '/var/ossec/etc/rootCA.pem':
            owner   => $khulnasoft::params_agent::keys_owner,
            group   => $khulnasoft::params_agent::keys_group,
            mode    => $khulnasoft::params_agent::keys_mode,
            content => $khulnasoft_manager_root_ca_pem,
            require => Package[$agent_package_name],
          }
          $agent_auth_option_manager = '-v /var/ossec/etc/rootCA.pem'
        } elsif $khulnasoft_manager_root_ca_pem_path != undef {
          validate_legacy(String, 'validate_string', $khulnasoft_manager_root_ca_pem)
          $agent_auth_option_manager = "-v ${khulnasoft_manager_root_ca_pem_path}"
        } else {
          $agent_auth_option_manager = ''  # Avoid errors when compounding final command
        }

        # https://documentation.khulnasoft.com/4.0/user-manual/registering/manager-verification/agent-verification-registration.html
        if ($khulnasoft_agent_cert != undef) and ($khulnasoft_agent_key != undef) {
          validate_legacy(String, 'validate_string', $khulnasoft_agent_cert)
          validate_legacy(String, 'validate_string', $khulnasoft_agent_key)
          file { '/var/ossec/etc/sslagent.cert':
            owner   => $khulnasoft::params_agent::keys_owner,
            group   => $khulnasoft::params_agent::keys_group,
            mode    => $khulnasoft::params_agent::keys_mode,
            content => $khulnasoft_agent_cert,
            require => Package[$agent_package_name],
          }
          file { '/var/ossec/etc/sslagent.key':
            owner   => $khulnasoft::params_agent::keys_owner,
            group   => $khulnasoft::params_agent::keys_group,
            mode    => $khulnasoft::params_agent::keys_mode,
            content => $khulnasoft_agent_key,
            require => Package[$agent_package_name],
          }

          $agent_auth_option_agent = '-x /var/ossec/etc/sslagent.cert -k /var/ossec/etc/sslagent.key'
        } elsif ($khulnasoft_agent_cert_path != undef) and ($khulnasoft_agent_key_path != undef) {
          validate_legacy(String, 'validate_string', $khulnasoft_agent_cert_path)
          validate_legacy(String, 'validate_string', $khulnasoft_agent_key_path)
          $agent_auth_option_agent = "-x ${khulnasoft_agent_cert_path} -k ${khulnasoft_agent_key_path}"
        } else {
          $agent_auth_option_agent = ''
        }

        $agent_auth_command = "${agent_auth_base_command} ${agent_auth_option_name} ${agent_auth_option_group} \
          ${agent_auth_option_manager}  ${agent_auth_option_agent} ${agent_auth_option_password} ${agent_auth_option_address}"

        exec { 'agent-auth-linux':
          command => $agent_auth_command,
          unless  => "/bin/egrep -q '.' ${::khulnasoft::params_agent::keys_file}",
          require => Concat['agent_ossec.conf'],
          before  => Service[$agent_service_name],
          notify  => Service[$agent_service_name],
        }

        service { $agent_service_name:
          ensure    => $agent_service_ensure,
          enable    => true,
          hasstatus => $khulnasoft::params_agent::service_has_status,
          pattern   => $khulnasoft::params_agent::agent_service_name,
          provider  => $khulnasoft::params_agent::ossec_service_provider,
          require   => Package[$agent_package_name],
        }
      }
      'windows': {
        $agent_auth_executable = "'C:\\Program Files (x86)\\ossec-agent\\agent-auth.exe'"
        $agent_auth_base_command = "& ${agent_auth_executable} -m \"${khulnasoft_register_endpoint}\""

        # TODO: Implement the support for Manager verification using SSL
        # TODO: Implement the support for Agent verification using SSL

        $agent_auth_command = "${agent_auth_base_command} ${agent_auth_option_name} ${agent_auth_option_group} \
          ${agent_auth_option_password}"

        exec { 'agent-auth-windows':
          command  => $agent_auth_command,
          provider => 'powershell',
          onlyif   => "if ((Get-Item '${$::khulnasoft::params_agent::keys_file}').length -gt 0kb) {exit 1}",
          require  => Concat['agent_ossec.conf'],
          before   => Service[$agent_service_name],
          notify   => Service[$agent_service_name],
        }

        service { $agent_service_name:
          ensure    => $agent_service_ensure,
          enable    => true,
          hasstatus => $khulnasoft::params_agent::service_has_status,
          pattern   => $khulnasoft::params_agent::agent_service_name,
          provider  => $khulnasoft::params_agent::ossec_service_provider,
          require   => Package[$agent_package_name],
        }
      }
      default: { fail('OS not supported') }
    }
  } else {
    service { $agent_service_name:
      ensure    => stopped,
      enable    => false,
      hasstatus => $khulnasoft::params_agent::service_has_status,
      pattern   => $agent_service_name,
      provider  => $khulnasoft::params_agent::ossec_service_provider,
      require   => Package[$agent_package_name],
    }
  }

  # SELinux
  # Requires selinux module specified in metadata.json
  if ($::osfamily == 'RedHat' and $selinux == true) {
    selinux::module { 'ossec-logrotate':
      ensure    => 'present',
      source_te => 'puppet:///modules/khulnasoft/ossec-logrotate.te',
    }
  }

  # Manage firewall
  if $manage_firewall {
    include firewall
    firewall { '1514 khulnasoft-agent':
      dport  => $ossec_port,
      proto  => $ossec_protocol,
      action => 'accept',
      state  => [
        'NEW',
        'RELATED',
        'ESTABLISHED',
      ],
    }
  }

  if ( $khulnasoft_enrollment_auth_pass ) {
    file { $khulnasoft::params_agent::authd_pass_file:
      owner   => 'root',
      group   => 'khulnasoft',
      mode    => '0640',
      content => $khulnasoft_enrollment_auth_pass,
      require => Package[$khulnasoft::params_agent::agent_package_name],
    }
  }

}
