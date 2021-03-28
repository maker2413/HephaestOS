#!/bin/bash

# Check to see where script is being run
cat /etc/hostname | grep archiso > /dev/null
if [[ $? == 0 ]]; then
  # Copy this script into mounted root
  echo "Copying this script to mounted root"
  cp /root/after-install.sh /mnt/root/after-install.sh

  # Change root into /mnt
  echo "Changing to mounted root"
  arch-chroot /mnt /root/after-install.sh

  # Clean up
  echo "Cleaning up scripts and files"
  rm -rf /mnt/root/ansible
  rm /mnt/root/after-install.sh

  # Exit program
  exit
fi

# Run ansible playbook
echo "Running ansible playbook"
cd /root/ansible
ansible-playbook playbooks/hephaestus.yml
