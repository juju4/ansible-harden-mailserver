[![Build Status - Master](https://travis-ci.org/juju4/ansible-harden-mailserver.svg?branch=master)](https://travis-ci.org/juju4/ansible-harden-mailserver)
[![Build Status - Devel](https://travis-ci.org/juju4/ansible-harden-mailserver.svg?branch=devel)](https://travis-ci.org/juju4/ansible-harden-mailserver/branches)

[![Actions Status - Master](https://github.com/juju4/ansible-harden-mailserver/workflows/AnsibleCI/badge.svg)](https://github.com/juju4/ansible-harden-mailserver/actions?query=branch%3Amaster)
[![Actions Status - Devel](https://github.com/juju4/ansible-harden-mailserver/workflows/AnsibleCI/badge.svg?branch=devel)](https://github.com/juju4/ansible-harden-mailserver/actions?query=branch%3Adevel)

# Mailserver hardening ansible role

Ansible role to harden mailserver system.
Currently only Postfix.

## Requirements & Dependencies

### Ansible
It was tested on the following versions:
 * 1.9
 * 2.0
 * 2.5

### Operating systems

Tested on Ubuntu 14.04, 16.04 and 18.04

## Example Playbook

Just include this role in your list.
For example

```
- host: all
  roles:
    - juju4.harden-mailserver
```

## Variables

Nothing specific for now.

## Continuous integration

This role has a travis basic test (for github), more advanced with kitchen and also a Vagrantfile (test/vagrant).

Once you ensured all necessary roles are present, You can test with:
```
$ cd /path/to/roles/juju4.harden-mailserver
$ kitchen verify
$ kitchen login
```
or
```
$ cd /path/to/roles/juju4.harden-mailserver/test/vagrant
$ vagrant up
$ vagrant ssh
```

## Troubleshooting & Known issues


## License

BSD 2-clause

