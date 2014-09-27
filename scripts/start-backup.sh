#!/bin/bash
connectstring="localhost:1186"
ndbd_hostnames="localhost localhost"
ndbd_datadir=`pwd`/../datadir/
targetdir=$1
subdir=BACKUP-`date +%Y%b%d'-'%H%M%S`
installdir=`pwd`/../install/
bindir=$installdir/mysql/bin/
libexec=$installdir/mysql/bin/

if [ -n "$targetdir" ]; then
	echo ""
	else
	echo "syntax: start-backup.sh  <directory on this host where backups will be copied to>"
	exit;
fi
printf "%s: %-80s\n" "sandbox" "Starting backup.. this can take some time. CTRL-C a couple of times will abort."
$bindir/ndb_mgm -c "$connectstring"  -e "start backup wait completed"
printf "%s: %-80s\n" "sandbox" "Backup has completed on data nodes."
printf "%s: %-80s\n" "sandbox" "Copying backup files to $targetdir/$subdir"
for host in ${ndbd_hostnames[@]}
do
	`mkdir -p $targetdir/$subdir/$host/` 
	cp -r $ndbd_datadir/BACKUP/*  $targetdir/$subdir/$host
	mv $targetdir/$subdir/$host/BACKUP-*/*  $targetdir/$subdir/ 
	rm -rf $targetdir/$subdir/$host
done
for host in ${ndbd_hostnames[@]}
do
rm -rf $ndbd_datadir/BACKUP/*
done
	printf "%s: %-80s\n" "sandbox" "Backup completed and backup files can be found in $targetdir/$subdir"
