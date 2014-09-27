#!/bin/bash
basedir=`pwd`/../install//mysql
datadir=`pwd`/../datadir/
mysql_datadir1=$datadir/mysql_1
mysql_datadir2=$datadir/mysql_2
mysql_datadir1_s=$datadir/mysql_1_s
mysql_datadir2_s=$datadir/mysql_2_s
mgm_datadir=$datadir
ndbd_datadir=$datadir
hostname="localhost"
cat ../config/config.ini.t | sed -e s,"_DATADIR","$datadir",g > ../config/config.ini
mycnf1=../config/my.cnf.1
mycnf2=../config/my.cnf.2
configini=../config/config.ini
installconfigpath=`pwd`/../config
mkdir -p $datadir
printf "%s: %-80s\n" "sandbox" "Installing mysql server on $hostname ...";tput el;
rm -rf $mysql_datadir1
rm -rf $mysql_datadir2
rm -rf $mysql_datadir1_s
rm -rf $mysql_datadir2_s
mkdir -p $mysql_datadir1
mkdir -p $mysql_datadir2
mkdir -p $mysql_datadir1_s
mkdir -p $mysql_datadir2_s
$basedir/scripts/mysql_install_db --defaults-file=$installconfigpath/my.cnf.1 --force --datadir=$mysql_datadir1 --basedir=$basedir
$basedir/scripts/mysql_install_db --defaults-file=$installconfigpath/my.cnf.2 --force --datadir=$mysql_datadir2 --basedir=$basedir
$basedir/scripts/mysql_install_db --defaults-file=$installconfigpath/my.cnf.1.s --force --datadir=$mysql_datadir1_s --basedir=$basedir
$basedir/scripts/mysql_install_db --defaults-file=$installconfigpath/my.cnf.2.s --force --datadir=$mysql_datadir2_s --basedir=$basedir
printf "\n%s: %-80s\n" "sandbox" "Done!"
