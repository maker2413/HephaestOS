#!/usr/bin/env bash

# Prompt for the hostname of the machine in question
echo "Hello, what is the hostname or ip of the machine you are trying to install arch linux on?"
read hostname

# Copy an ssh key to the machine for passwordless login
ssh-copy-id -i ~/.ssh/id_rsa.pub "root@$hostname"

# Copying the base-install script and ansible playbook
echo "Copying install script and ansible playbook to machine:"
scp -r ./* root@$hostname:/root/

# Rune the base-install bash script
echo "Running install script on machine:"
ssh -t root@$hostname "./base-install.sh"

# Running the ansible playbook
echo "Running ansible playbook"
