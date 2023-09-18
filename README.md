# Khulnasoft Puppet module

[![Slack](https://img.shields.io/badge/slack-join-blue.svg)](https://khulnasoft.com/community/join-us-on-slack/)
[![Email](https://img.shields.io/badge/email-join-blue.svg)](https://groups.google.com/forum/#!forum/khulnasoft)
[![Documentation](https://img.shields.io/badge/docs-view-green.svg)](https://documentation.khulnasoft.com)
[![Web](https://img.shields.io/badge/web-view-green.svg)](https://khulnasoft.com)
![Kitchen tests for Khulnasoft Puppet](https://github.com/khulnasoft/khulnasoft-puppet/workflows/Kitchen%20tests%20for%20Khulnasoft%20Puppet/badge.svg)

This module installs and configure Khulnasoft agent and manager.

## Documentation

* [Full documentation](http://documentation.khulnasoft.com)
* [Khulnasoft Puppet module documentation](https://documentation.khulnasoft.com/current/deploying-with-puppet/index.html)
* [Puppet Forge](https://forge.puppetlabs.com/khulnasoft/khulnasoft)

## Directory structure

    khulnasoft-puppet/
    ├── CHANGELOG.md
    ├── checksums.json
    ├── data
    │   └── common.yaml
    ├── files
    │   └── ossec-logrotate.te
    ├── Gemfile
    ├── kitchen
    │   ├── chefignore
    │   ├── clean.sh
    │   ├── Gemfile
    │   ├── hieradata
    │   │   ├── common.yaml
    │   │   └── roles
    │   │       └── default.yaml
    │   ├── kitchen.yml
    │   ├── manifests
    │   │   └── site.pp.template
    │   ├── Puppetfile
    │   ├── README.md
    │   ├── run.sh
    │   └── test
    │       └── integration
    │           ├── agent
    │           │   └── agent_spec.rb
    │           └── mngr
    │               └── manager_spec.rb
    ├── LICENSE.txt
    ├── manifests
    │   ├── activeresponse.pp
    │   ├── addlog.pp
    │   ├── agent.pp
    │   ├── audit.pp
    │   ├── certificates.pp
    │   ├── command.pp
    │   ├── dashboard.pp
    │   ├── email_alert.pp
    │   ├── filebeat_oss.pp
    │   ├── indexer.pp
    │   ├── init.pp
    │   ├── integration.pp
    │   ├── manager.pp
    │   ├── params_agent.pp
    │   ├── params_manager.pp
    │   ├── repo_elastic_oss.pp
    │   ├── repo.pp
    │   ├── reports.pp
    │   └── tests.pp
    ├── metadata.json
    ├── Rakefile
    ├── README.md
    ├── spec
    │   ├── classes
    │   │   ├── client_spec.rb
    │   │   ├── init_spec.rb
    │   │   └── server_spec.rb
    │   └── spec_helper.rb
    ├── templates
    │   ├── default_commands.erb
    │   ├── filebeat_oss_yml.erb
    │   ├── fragments
    │   │   ├── _activeresponse.erb
    │   │   ├── _auth.erb
    │   │   ├── _cluster.erb
    │   │   ├── _command.erb
    │   │   ├── _default_activeresponse.erb
    │   │   ├── _email_alert.erb
    │   │   ├── _integration.erb
    │   │   ├── _labels.erb
    │   │   ├── _localfile.erb
    │   │   ├── _localfile_generation.erb
    │   │   ├── _reports.erb
    │   │   ├── _rootcheck.erb
    │   │   ├── _ruleset.erb
    │   │   ├── _sca.erb
    │   │   ├── _syscheck.erb
    │   │   ├── _syslog_output.erb
    │   │   ├── _vulnerability_detector.erb
    │   │   ├── _wodle_cis_cat.erb
    │   │   ├── _wodle_openscap.erb
    │   │   ├── _wodle_osquery.erb
    │   │   └── _wodle_syscollector.erb
    │   ├── disabledlog4j_options.erb
    │   ├── local_decoder.xml.erb
    │   ├── local_rules.xml.erb
    │   ├── ossec_shared_agent.conf.erb
    │   ├── process_list.erb
    │   ├── khulnasoft_agent.conf.erb
    │   ├── khulnasoft_api_yml.erb
    │   ├── khulnasoft_config_yml.erb
    │   ├── khulnasoft_manager.conf.erb
    │   └── khulnasoft_yml.erb
    └── VERSION

## Branches

* `master` branch contains the latest code, be aware of possible bugs on this branch.
* `stable` branch on correspond to the last Khulnasoft-Puppet stable version.

## Contribute

If you want to contribute to our project please don't hesitate to send a pull request. You can also join our users [mailing list](https://groups.google.com/d/forum/khulnasoft) or the [Khulnasoft Slack community channel](https://khulnasoft.com/community/join-us-on-slack/) to ask questions and participate in discussions.

## Credits and thank you

This Puppet module has been authored by Nicolas Zin, and updated by Jonathan Gazeley and Michael Porter. Khulnasoft has forked it with the purpose of maintaining it. Thank you to the authors for the contribution.

## License and copyright

KHULNASOFT
Copyright (C) 2015, Khulnasoft Inc.  (License GPLv2)

## Web References

* [Khulnasoft website](http://khulnasoft.com)
