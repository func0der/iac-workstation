# iac-workstation

## **⚠️⚠️⚠️ This repository is a WIP and is not intended for public use (yet) ⚠️⚠️⚠️**

If you really want to use this repo for your machines, please ready through the files
carefully.

There is personalization in there, that does not apply to you as well as
quick and dirty solutions (for a lack of testing), that may cause harm to your
systems.

Please make extensive use of the `--check` flag of `ansible`.

## What to expect

This repository contains workstation configurations.

It should ultimately replace my dotfiles and make it easier to switch between distros without
the overhead of installing EVERYTHING by hand afterward.

## Assumptions

  * Distros
    * Debian-based
    * Fedora-based (RedHat not tested)
  * Gnome desktop environment
  * Ansible 2.15.8+

## How to use

### Install `ansible`

There are an auto installers for `ansible` in [./bin](./bin), which works
with the above assumptions.

If you do not want to use that script, install `ansible` however you want
on your system.

For Debian based system this could look like this:

```bash
sudo apt install ansible
```

Please be aware that if you do not have the newest version of `ansible`
the playbook could fail unexpectedly (see [Assumptions](#assumptions)).

### Install `ansible` requirements

```bash
ansible-galaxy install -r ansible/requirements.yml
```

### Adjust config

You find a config template in `ansible/group_vars/all.yml.dist`.

Copy it to `ansible/group_vars/all.yml` and configure to your liking.

### Run `common` playbook

There is currently no proper structure and there might be some implicit
dependencies between the base and any other playbook.

```bash
./bin/apply_common.sh
```

### Run whatever playbook suites your needs

Find available commands in the `bin` folder and use them to your liking.
You are free to turn to `ansible-playbook` directly, if you want to.

```bash
./bin/apply_....sh
```

## Ideas

  * Split into playbooks for different use cases 
    * Base
    * Development
    * Gaming
    * (Office)
  * Also check that the system is setup properly
    * Encryption of hard drive? if possible
    * (BTRFS for /root)
  * Try to be distro agnostic
    * Maybe use **only** flatpaks?
      * Check `docker` on this 
  * Make proper shortcut scripts for easier handling of playbooks
  * (Setup of ansible via script) 


## Inspiration

  - https://galaxy.ansible.com/ui/repo/published/sylvainmetayer/workstation/
