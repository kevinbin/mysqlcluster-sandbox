#!/bin/bash
localconfigpath=`pwd`/../config
configini=$localconfigpath/config.ini
connectstring="localhost:1186"
installdir=`pwd`/../install/
bindir=$installdir/mysql/bin/
libexec=$installdir/mysql/bin/
libdir=$installdir/mysql/lib/

ndbd_datadir=
mgmd_datadir=
hostname="localhost"
printf "%s: %-80s\n" "sandbox" "MySQL Servers are stopping. It can take a couple of minutes for it to terminate..."
LD_LIBRARY_PATH=$libdir:$libdir/mysql $bindir/mysqladmin -S /tmp/mysql.sock.3306 -uroot shutdown 
LD_LIBRARY_PATH=$libdir:$libdir/mysql $bindir/mysqladmin -S /tmp/mysql.sock.3307 -uroot shutdown 
sleep 1
$bindir/ndb_mgm -c "localhost:1186"  -e "all stop"
printf "%s: %-80s\n" "sandbox" "Data nodes are stopping. This can take a few minutes..."
sleep 1
$bindir/ndb_waiter -n -c "localhost:1186"  > /dev/null
$bindir/ndb_mgm -c "localhost:1186"  -e show
killall -9 ndb_mgmd
printf "%s: %-80s\n" "sandbox" "Terminating management server..."
sleep 1
killall -9 mysqld
killall -9 ndbd
printf "%s: %-80s\n" "sandbox" "Making sure MySQL Servers and data nodes are terminated..."
sleep 1
printf "%s: %-80s\n" "sandbox" "Cluster is stopped"
exit;
