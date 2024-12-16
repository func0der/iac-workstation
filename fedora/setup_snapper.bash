#!/bin/bash

# @see https://sysguides.com/install-fedora-with-snapshot-and-rollback-support/

#### Get the UUID of your btrfs system root.
ROOT_UUID="$(sudo grub2-probe --target=fs_uuid /)"

echo $ROOT_UUID

#### Get the btrfs subvolume mount options from your fstab.
OPTIONS="$(grep '/home' /etc/fstab | awk '{print $4}' | cut -d, -f2-)"

echo $OPTIONS

#### Declare rest of the subvolumes you want to create in the array.
#### Copy from 'SUBVOLUMES' to ')', paste it in terminal, and hit <Enter>.
SUBVOLUMES=(
    "var/cache"
    "var/crash"
    "var/log"
    "var/spool"
    "var/tmp"
    "var/www"
    "var/lib/AccountsService"
    "var/lib/gdm"
    # "opt" # deliberately not creating this. Rollback should include those applications.
    # "var/lib/libvirt/images" # deliberately not creating this. No usecase
    # "home/$USER/.mozilla"  # deliberately not creating this. Not snapping /home anyway
)

echo ${SUBVOLUMES[@]}

#### Run the for loop to create the subvolumes.
#### Copy from 'for' to 'done', paste it in terminal, and hit <Enter>.
for dir in "${SUBVOLUMES[@]}" ; do
    SUBVOL_EXISTS=$(sudo btrfs subvolume show "/${dir}") && continue;

    if [[ -d "/${dir}" ]] ; then
        sudo mv -v "/${dir}" "/${dir}-old"
        sudo btrfs subvolume create "/${dir}"
        sudo cp -ar "/${dir}-old/." "/${dir}/"
    else
        sudo btrfs subvolume create "/${dir}"
    fi
    # Restore selinux stuff
    sudo restorecon -RF "/${dir}"

    # Use 'root/' as subvol prefix here, because we are using a subvol for /
    # This might not be the default configuration that Fedora uses in its installer
    printf "%-41s %-24s %-5s %-s %-s\n" \
        "UUID=${ROOT_UUID}" \
        "/${dir}" \
        "btrfs" \
        "subvol=root/${dir},${OPTIONS}" \
        "0 0" | \
        sudo tee -a /etc/fstab
done

sudo systemctl daemon-reload

# Install snapper
sudo dnf install snapper

# Configure snapper
sudo snapper -c root create-config /

grep '/.snapshots' /etc/fstab > /dev/null || printf "%-41s %-24s %-5s %-s %-s\n" \
    "UUID=${ROOT_UUID}" \
    "/.snapshots" \
    "btrfs" \
    "subvol=root/.snapshots,${OPTIONS}" \
    "0 0" | \
    sudo tee -a /etc/fstab

sudo systemctl daemon-reload

mount -l | grep '.snapshots' > /dev/null || sudo mount /.snapshots

if [[ ! $(grep '.snapshots' /etc/updatedb.conf) ]]; then
    echo 'Please add '

    echo 'PRUNENAMES = ".snapshots"'

    echo 'to "/etc/updatedb.conf. I will wait... Press any key to continue."'

    read
fi

# Configure snapper during updates
if [ -x $(command -v dnf5 >/dev/null 2>&1) ]; then

  sudo dnf install libdnf5-plugin-actions

  # @see https://github.com/rpm-software-management/dnf5/issues/702
  sudo mkdir -p /etc/dnf/libdnf5-plugins/actions.d

  cat <<- "ACTION_DEFINITION" | sudo tee /etc/dnf/libdnf5-plugins/actions.d/snapper.actions
# Get snapshot description
pre_transaction::::/usr/bin/sh -c echo\ "tmp.cmd=$(ps\ -o\ command\ --no-headers\ -p\ '${pid}')"
# Creates pre snapshot before the transaction and stores the snapshot number in the "tmp.snapper_pre_number"  variable.
pre_transaction::::/usr/bin/sh -c echo\ "tmp.snapper_pre_number=$(snapper\ create\ -t\ pre\ -p\ -d\ '${tmp.cmd}')"

# If the variable "tmp.snapper_pre_number" exists, it creates post snapshot after the transaction and removes the variable "tmp.snapper_pre_number".
post_transaction::::/usr/bin/sh -c [\ -n\ "${tmp.snapper_pre_number}"\ ]\ &&\ snapper\ create\ -t\ post\ --pre-number\ "${tmp.snapper_pre_number}"\ -d\ "${tmp.cmd}"\ ;\ echo\ tmp.snapper_pre_number\ ;\ echo\ tmp.cmd
ACTION_DEFINITION

else
  sudo dnf install python3-dnf-plugin-snapper
fi


grep 'SUSE_BTRFS_SNAPSHOT_BOOTING=' /etc/default/grub > /dev/null || echo 'SUSE_BTRFS_SNAPSHOT_BOOTING="true"' | sudo tee -a /etc/default/grub
sudo grep 'btrfs_relative_path' /boot/efi/EFI/fedora/grub.cfg > /dev/null || sudo sed -i '1i set btrfs_relative_path="yes"' /boot/efi/EFI/fedora/grub.cfg
sudo grub2-mkconfig -o /boot/grub2/grub.cfg


# Setup grub-btrfs
if [[ ! $(command -v grub-btrfsd) ]]; then
    # We need make (no cleanup, stays on system)
    sudo dnf install make inotify-tools

    # Checkout
    GRUB_BTRFS_GIT_DIR=/tmp/grub-btrfs-git
    git clone https://github.com/Antynea/grub-btrfs "${GRUB_BTRFS_GIT_DIR}"

    # We want to get back here later on
    CUR_DIR=$(pwd)

    # Configure for fedora
    cd "${GRUB_BTRFS_GIT_DIR}"

    sed -i '/#GRUB_BTRFS_SNAPSHOT_KERNEL/a GRUB_BTRFS_SNAPSHOT_KERNEL_PARAMETERS="systemd.volatile=state"' config
    sed -i '/#GRUB_BTRFS_GRUB_DIRNAME/a GRUB_BTRFS_GRUB_DIRNAME="/boot/grub2"' config
    sed -i '/#GRUB_BTRFS_MKCONFIG=/a GRUB_BTRFS_MKCONFIG=/sbin/grub2-mkconfig' config
    sed -i '/#GRUB_BTRFS_SCRIPT_CHECK=/a GRUB_BTRFS_SCRIPT_CHECK=grub2-script-check' config

    sudo make install

    sudo grub2-mkconfig -o /boot/grub2/grub.cfg
    sudo systemctl enable --now grub-btrfsd.service

    cd "${CUR_DIR}"
    sudo rm -r "${GRUB_BTRFS_GIT_DIR}"
fi

sudo btrfs subvolume set-default $(sudo btrfs inspect-internal rootid /) /
