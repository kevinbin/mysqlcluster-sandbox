#!/bin/bash
localconfigpath=`pwd`/../config
mycnf=$localconfigpath/my.cnf.1.s
installdir=`pwd`/../install/
basedir=$installdir/mysql
datadir=`pwd`/../datadir/
libexec=$installdir/mysql/bin/

$libexec/mysqld --defaults-file=$mycnf --datadir=$datadir/mysql_1_s --basedir=$basedir --user=$LOGNAME &
sleep 5
bash show.sh

exit;
