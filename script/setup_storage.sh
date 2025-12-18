#!/bin/bash
set -e

DISK="/dev/sdb"
PART="/dev/sdb1"

VG="vg_app1"
LV_APP="lv_app1"
LV_CACHE="lv_cache_app1"

APP_MNT="/var/app1"
CACHE_MNT="/var/cache/app1"

# 1) Partition disk
parted -s "$DISK" mklabel gpt
parted -s "$DISK" mkpart primary 1MiB 100%
parted -s "$DISK" set 1 lvm on
partprobe "$DISK"

# 2) Create LVM
pvcreate "$PART"
vgcreate "$VG" "$PART"

lvcreate -n "$LV_APP" -L 2g "$VG"
lvcreate -n "$LV_CACHE" -l 100%FREE "$VG"

# 3) Filesystems
mkfs.ext4 "/dev/$VG/$LV_APP"
mkfs.ext4 "/dev/$VG/$LV_CACHE"

# 4) Mount points
mkdir -p "$APP_MNT" "$CACHE_MNT"

# 5) Persistent mount
mount "/dev/$VG/$LV_APP" "$APP_MNT"
grep -q "$APP_MNT" /etc/fstab || \
echo "/dev/$VG/$LV_APP $APP_MNT ext4 defaults 0 0" >> /etc/fstab

# 6) Runtime-only mount
mount "/dev/$VG/$LV_CACHE" "$CACHE_MNT"

echo "Setup complete. Reboot to verify behavior."

