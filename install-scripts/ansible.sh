#!/bin/bash

# Run ansible playbook and check for efi
echo "Running ansible playbook"
cd /root/ansible
ls efi > /dev/null
if [[ $? == 0 ]]; then
  ansible-playbook playbooks/hephaestus.yml -e efi=true -e install_grub=true
else
  ansible-playbook playbooks/hephaestus.yml -e install_grub=true
fi
