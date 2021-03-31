#!/usr/bin/env bash

# Prompt for the hostname of the machine in question
echo "Hello, what is the hostname or ip of the machine you are trying to install arch linux on?"
read hostname

# Copy an ssh key to the machine for passwordless login
ssh-copy-id -i ~/.ssh/id_rsa.pub "root@$hostname"

# Copying the base-install script and ansible playbook
echo "Copying install script and ansible playbook to machine:"
scp -r install-scripts root@$hostname:/root/

# Rune the base-install bash script
echo "Running install script on machine:"
ssh -t root@$hostname "/root/install-scripts/before-install.sh"

# Copying ansible playbook
echo "Copying ansible playbook"
scp -r .ansible_vault ansible.cfg inventory host_vars roles playbooks root@$hostname:/mnt/root/ansible

# Running post install script
echo "Running post install script"
ssh -t root@$hostname "/root/install-scripts/after-install.sh"

# Shutdown
echo "Shutting down System to finish install"
ssh -t root@$hostname "shutdown now"
