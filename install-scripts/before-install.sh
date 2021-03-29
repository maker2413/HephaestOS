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
IS_FORMATTED=`ls /mnt | wc -l`
if [[ $IS_FORMATTED == 0 ]]; then
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

      mkfs.fat -F32 "/dev/$EFI"
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
fi

# Mount file systems
echo "Mounting the file system:"
if grep -qa '/mnt' /proc/mounts; then
  echo "file system already mounted"
else
  mount "/dev/$ROOT" /mnt
fi

# Mount EFI if created
if [[ $IS_EFI =~ (yes)|(y)|(Y) ]]; then
  mkdir /mnt/boot
  mount "/dev/$EFI" /mnt/boot
fi

# Turn on swap if created
if [[ $IS_SWAP =~ (yes)|(y)|(Y) ]]; then
  swapon "/dev/$SWAP"
fi

# Install Base System
echo "Installing the base linux system:"
pacstrap /mnt ansible base dhcpcd linux linux-firmware

# Install efibootmgr is efi created
if [[ $IS_EFI =~ (yes)|(y)|(Y) ]]; then
  echo "Installed efibootmgr"
  pacstrap /mnt efibootmgr
fi

# Generate fstab
echo "Generating fstab file:"
genfstab -U /mnt >> /mnt/etc/fstab

# End
mkdir /mnt/root/ansible
echo "Base system install finished!"

# Note if EFI for ansible
touch /mnt/root/ansible/efi
