#!/bin/bash
localconfigpath=`pwd`/../config
mycnf=$localconfigpath/my.cnf.1
installdir=`pwd`/../install/
bindir=$installdir/mysql/bin/

libdir=$installdir/mysql/lib/

LD_LIBRARY_PATH=$libdir:$libdir/mysql $bindir/mysql -S/tmp/mysql.sock.3306 -uroot test
