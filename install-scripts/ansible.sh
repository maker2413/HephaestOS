#!/bin/bash

# Run ansible playbook
echo "Running ansible playbook"
cd /root/ansible
ansible-playbook playbooks/hephaestus.yml
