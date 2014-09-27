#!/bin/bash
installdir=`pwd`/../install/
bindir=$installdir/mysql/bin/
libdir=$installdir/mysql/lib/

LD_LIBRARY_PATH=$libdir:$libdir/mysql $bindir/mysqladmin -S /tmp/mysql.sock.3306 -uroot shutdown 
sleep 1
bash show.sh

exit;
