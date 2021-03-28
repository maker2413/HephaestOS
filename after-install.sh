#!/bin/bash

# Change root into /mnt
echo "Changing to mounted root"
arch-chroot /mnt

# Run ansible playbook
cd /root/ansible
ansible-playbook playbooks/hephaestus.yml
