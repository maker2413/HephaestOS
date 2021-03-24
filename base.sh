#!/usr/bin/env bash

# Prompt for the hostname of the machine in question
echo "Hello, what is the hostname or ip of the machine you are trying to install arch linux on?"
read hostname

# Copy an ssh key to the machine for passwordless login
ssh-copy-id -i ~/.ssh/id_rsa.pub "root@$hostname"

# Copy and run the base-install script
echo "Copying install script to machine:"
scp base-install.sh root@$hostname:/root/
echo "Running install script on machine:"
ssh -t root@$hostname "./base-install.sh"
