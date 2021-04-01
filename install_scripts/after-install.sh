#!/bin/bash

# Copy this script into mounted root
echo "Copying this script to mounted root"
cp /root/install_scripts/ansible.sh /mnt/root/ansible.sh

# Change root into /mnt
echo "Changing to mounted root"
arch-chroot /mnt /root/ansible.sh

# Clean up
echo "Cleaning up scripts and files"
rm -rf /mnt/root/ansible
rm /mnt/root/ansible.sh
