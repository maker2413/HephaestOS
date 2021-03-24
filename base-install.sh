#!/usr/bin/env bash

# Begin
echo "Beginning initial Arch linux install"

# figure out if uefi or bios
if [ -d /sys/firmware/efi ]; then
  BIOS_TYPE="uefi"
else
  BIOS_TYPE="bios"
fi

# Open cfdisk to allow disk partitioning
echo "Open cfdisk:"
DISKS="ls /dev/ | grep -E 'sda|vda'"
DISKS_LIST=(`eval $DISKS`)
DRIVE=${DISKS_LIST[0]}
cfdisk "/dev/$DRIVE"

# Formatting the drives
echo "Formatting the drives:"
DISKS_LIST=(`eval $DISKS`)
echo "Did you make a swap partition? (Y/n)"
read IS_SWAP
if [[ $IS_SWAP =~ (yes)|(y)|(Y) ]]; then
  echo "Which partition is the swap partition?"
  echo "--------------------------------------"
  echo "${DISKS_LIST[*]}"
  read SWAP

  mkswap "/dev/$SWAP"
  if [[ $? != 0 ]]; then
    echo "mkswap failed"
    exit 1
  fi
fi

if [[ $BIOS_TYPE == "uefi" ]]; then
  echo "Did you make an efi partition? (Y/n)"
  read IS_EFI
  if [[ $IS_EFI =~ (yes)|(y)|(Y) ]]; then
    echo "Which partition is the efi partition?"
    echo "--------------------------------------"
    echo "${DISKS_LIST[*]}"
    read EFI

    mkfs.ext2 "/dev/$EFI"
    if [[ $? != 0 ]]; then
      echo "mkfs failed"
      exit 1
    fi
  fi
fi

echo "Which partition is your root partition?"
echo "--------------------------------------"
echo "${DISKS_LIST[*]}"
read ROOT

mkfs.ext4 "/dev/$ROOT"
if [[ $? != 0 ]]; then
  echo "mkfs failed"
  exit 1
fi

# Mount file systems
echo "Mounting the file system:"
mount "/dev/$ROOT" /mnt
if [[ $IS_SWAP =~ (yes)|(y)|(Y) ]]; then
  swapon "/dev/$SWAP"
fi

# Install Base System
echo "Installing the base linux system:"
pacstrap /mnt base linux linux-firmware

# Generate fstab
echo "Generating fstab file:"
genfstab -U /mnt >> /mnt/etc/fstab

# End
echo "Base system install finished!"
