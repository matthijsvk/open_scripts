#!/bin/bash
# The purpose of this script is to provide backup,
# restoration and cleaning services for a USB drive.
# There are three services provided:
# - perform a backup of a USB drive to a file
# (partition) image.
# - restore a USB drive from an file (partition) image
# - wipe a USB drive with random data.
 
function usage
{
   echo "usage: manageUSB [[-f backupfile ] [-d usbdrive] [-b] [-r] [-w]] | [-h]]"
   echo ""
   echo "   -f, --file (optional) name of backup file"
   echo "   -d, --drive (optional) name of USB drive"
   echo "   -b, --backup  perform a backup of the USB"
   echo " -r, --restore    restore a backup to the USB"
   echo "  -w, --wipe      wipe the USB with random data"
   echo ""
}
 
function backup
{
   echo "Beginning backup of USB drive..."
   dcfldd conv=notrunc,noerror bs=4096 if=$usbDrive | gzip > $backupFilename
   echo "Backup of USB drive complete."
}
 
function restore
{
   echo "Beginning restoration of USB drive..."
   gzip -dc $backupFilename | dcfldd of=$usbDrive
   echo "Restoration of USB drive complete."
}
 
function wipe
{
   echo "Wiping USB drive..."
   dcfldd bs=65536 if=/dev/urandom of=$usbDrive
}
 
## Main
 
interactive=
RIGHT_NOW=$(date +"%F_%Hh%Mmins")
backupFilename="USB_backup_$RIGHT_NOW.gz"
usbDrive=/dev/sdg1
 
while [ "$1" != "" ]; do
 case $1 in
   -f | --file )         shift
   backupFilename=$1
   ;;
   -d | --drive )     shift
   usbDrive=$1
   ;;
   -b | --backup )  backup
   exit
   ;;
   -r | --restore )  restore
   exit
   ;;
   -w | --wipe )   wipe
   exit
   ;;
   -h | --help )     usage
   exit
   ;;
   * )             usage
   exit 1
 esac
shift
done
 
if [ $# -eq 0 ]; then
usage
fi
