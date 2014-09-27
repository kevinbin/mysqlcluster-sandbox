#!/bin/bash
connectstring="localhost:1186"
installdir=`pwd`/../install/
bindir=$installdir/mysql/bin/

$bindir/ndb_mgm -c "localhost:1186"  -e "all status"
