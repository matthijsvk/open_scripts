#!/bin/bash
# ----------------------------------------------------------------------
# mikes handy rotating-filesystem-snapshot utility
# ----------------------------------------------------------------------
# this needs to be a lot more general, but the basic idea is it makes
# rotating backup-snapshots of /home whenever called
# ----------------------------------------------------------------------
# see http://www.mikerubel.org/computers/rsync_snapshots/#Incremental
# and www.rsnapshot.org

#unset PATH	# suggestion from H. Milz: avoid accidental use of $PATH
nbBACKUPS=3
nbBACKUPSminus1=$($nbBACKUPS - 1);
nbBACKUPSminus2=$($nbBACKUPS - 2);
nbBACKUPSplus1=$($nbBACKUPS + 1);

# ------------- system commands used by this script --------------------
ID=/usr/bin/id;
ECHO=/bin/echo;

MOUNT=/bin/mount;
RM=/bin/rm;
MV=/bin/mv;
CP=/bin/cp;
TOUCH=/bin/touch;

RSYNC=/usr/bin/rsync;


# ------------- file locations -----------------------------------------

MOUNT_DEVICE=;  		## Set these variables to the correct values
SNAPSHOT=;
EXCLUDES_FILE=./make_snapshot_exclude;

# ------------- the script itself --------------------------------------

# make sure we're running as root
if (( `$ID -u` != 0 )); then { $ECHO "Sorry, must be root.  Exiting..."; exit; } fi

# attempt to remount the RW mount point as RW; else abort
#$MOUNT -o remount,rw,bind $MOUNT_DEVICE $SNAPSHOT ;
#if (( $? )); then
#{
#	$ECHO "snapshot: could not remount $SNAPSHOT readwrite";
#	exit;
#}
#fi;

# make backup directories if they don't exist yet
eval mkdir -p $SNAPSHOT/home/hourly.{0..$nbBACKUPS};

# rotating snapshots of /home (fixme: this should be more general)

# step 1: delete the oldest snapshot, if it exists:
if [ -d $SNAPSHOT/home/hourly.$nbBACKUPSminus1 ] ; then			\
$RM -rf $SNAPSHOT/home/hourly.$nbBACKUPSminus1 ;				\
fi ;

# step 2: shift the middle snapshots(s) back by one, if they exist
for i in {$nbBACKUPSminus2..1}
do
	if [ -d $SNAPSHOT/home/hourly.$i ] ; then			\
	$MV $SNAPSHOT/home/hourly.$i $SNAPSHOT/home/hourly.$($i+1) ;	\
	fi;
done

# step 3: make a hard-link-only (except for dirs) copy of the latest snapshot,
# if that exists
if [ -d $SNAPSHOT/home/hourly.0 ] ; then			\
$CP -al $SNAPSHOT/home/hourly.0 $SNAPSHOT/home/hourly.1 ;	\
fi;

# step 4: rsync from the system into the latest snapshot (notice that
# rsync behaves like cp --remove-destination by default, so the destination
# is unlinked first.  If it were not so, this would copy over the other
# snapshot(s) too!
$RSYNC								\
	-va --delete --delete-excluded				\
	--exclude-from=$EXCLUDES_FILE				\
	/home/ $SNAPSHOT/home/hourly.0 ;

# step 5: update the mtime of hourly.0 to reflect the snapshot time
$TOUCH $SNAPSHOT/home/hourly.0 ;

# and thats it for home.

# now remount the RW snapshot mountpoint as readonly

#$MOUNT -o remount,ro,bind $MOUNT_DEVICE $SNAPSHOT ;
#if (( $? )); then
#{
#	$ECHO "snapshot: could not remount $SNAPSHOT readonly";
#	exit;
#} fi;
