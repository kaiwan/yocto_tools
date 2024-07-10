#!/bin/bash
# Part of the 'yocto_tools' GitHub repo
# 'A small, simple and useful tool collection for Yocto'
#  https://github.com/kaiwan/yocto_tools
# (c) Kaiwan NB, kaiwanTECH
# License: MIT

# burn4rpi_usbsd
# A very simple wrapper over dd, for the common case of burning the (micro)
# SDcard image generated by Yocto for the Raspberry Pi onto a USB-connected SDcard reader.
# F.e:
# ./burn4rpi_usbsd.sh /opt/yocto/poky/build_rpi/tmp/deploy/images/raspberrypi3-64/core-image-base-raspberrypi3-64.rpi-sdimg
#
name=$(basename $0)
# TODO / RELOOK: don't hardcode ofdisk!
ofdisk=sda
interactive=1  # let's just keep this ON for safety...

[ $# -eq 0 ] && {
  echo "Usage: ${name} [-i] {path-to-rpi-sdimg-file}
 -i : interactive mode"
  exit 1
}
if [ $# -eq 1 ]; then
  IMG=$(realpath ${1})
elif [ $# -eq 2 ]; then
  [ "$1" = "-i" ] && interactive=1
  IMG=$(realpath ${2})
fi

[ -z "${IMG}" ] && {
  echo "${name}: image file to burn isn't specified correctly? Aborting..."
  exit 1
}
[ ! -f ${IMG} ] && {
  echo "${name}: specified file \"${IMG}\" doesn't exist (or lacking perms?) Aborting..."
  exit 1
}
echo "Image file (via realpath) is:"
ls -lh ${IMG}

echo "Enter output disk name (eg. sda, sdb, mmcblk0, ...):
Tip: lookup the block device name via df or lsblk : "
read ofdisk

lsblk | grep -q "${ofdisk}" || {
  echo "${name}: lsblk failed to find output disk \"${ofdisk}\" ? Aborting..."
  exit 1
}

OF_DEV=/dev/${ofdisk}
cmd="sudo umount ${OF_DEV}* 2>/dev/null; sync"
eval "${cmd}"

cmd="time sudo dd if=${IMG} of=${OF_DEV} bs=4k"
echo "
${cmd}
"

[ ${interactive} -eq 1 ] && {
 read -p "Please CAREFULLY VERIFY that this command is OK to run,
ESPECIALLY the 'of' device !!!

Press [Enter] to continue, ^C to abort ... "
}

echo "[+] $(date): writing, pl wait ..."
eval "${cmd}"
echo "done, sync-ing now..."
sync
