#!/bin/bash
localconfigpath=`pwd`/../config
mycnf=$localconfigpath/my.cnf.2.s
installdir=`pwd`/../install/
basedir=$installdir/mysql
datadir=`pwd`/../datadir/
libexec=$installdir/mysql/bin/

$libexec/mysqld --defaults-file=$mycnf --datadir=$datadir/mysql_2_s --basedir=$basedir --user=$LOGNAME &
sleep 5
bash show.sh

exit;
