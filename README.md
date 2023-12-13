# iac-workstation

## **⚠️⚠️⚠️ This repository is a WIP and is not intended for public use (yet) ⚠️⚠️⚠️**

If you really want to use this repo for your machines, please ready through the files
carefully.

There is personalization in there, that does not apply to you as well as
quick and dirty solutions (for a lack of testing), that may cause harm to your
systems.

## What to expect

This repository contains workstation configurations.

It should ultimately replace my dotfiles and make it easier to switch between distros without
the overhead of installing EVERYTHING by hand afterward.

## Assumptions

  * Gnome desktop (for now)
  * Debian based host (for now)

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
