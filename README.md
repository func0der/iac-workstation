# iac-workstation

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
