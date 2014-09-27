#!/bin/bash
localconfigpath=`pwd`/../config
configini=$localconfigpath/config.ini
installdir=`pwd`/../install/
connectstring="localhost:1186"
libexec=$installdir/mysql/bin/

$libexec/ndb_mgmd -c "localhost:1186" -f $configini --configdir=$localconfigpath --reload --initial
