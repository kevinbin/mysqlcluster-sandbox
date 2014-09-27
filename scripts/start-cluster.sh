#!/bin/bash
TEMP=`getopt -oh,i --long initial,help -n 'start-cluster.sh' -- "$@"`
eval set -- "$TEMP"
tput init; tput clear;tput sc
help=""
initial=""
while true ; do
   case "$1" in
      -i|--initial) initial="1" ; shift ;;
      -h|--help) help="1" ; shift ;;
      --) shift ; break ;;
      *) echo "Internal error!" ; exit 1 ;;
   esac
done
if [ "${help}" = "1" ]; then
  echo "usage: ./start-cluster.sh [-i|--initial] "
  echo "-i|--initial -- initial start of cluster -- clears out all data"
  exit
fi
localconfigpath=`pwd`/../config
configini=$localconfigpath/config.ini
mycnf1=$localconfigpath/my.cnf.1
mycnf2=$localconfigpath/my.cnf.2
connectstring="localhost:1186"
datadir=`pwd`/../datadir/
installdir=`pwd`/../install/
basedir=`pwd`/../install//mysql
ndbd_datadir=$datadir
mgmd_datadir=$datadir
mysql_datadir1=$datadir/mysql_1
mysql_datadir2=$datadir/mysql_2
hostname=localhost
bindir=$installdir/mysql/bin/

libexec=$installdir/mysql/bin/

printf "%s: %-80s\n" "sandbox" "Starting management server ..."
$libexec/ndb_mgmd -c "$connectstring"  -f $configini --configdir=$localconfigpath --reload --initial
sleep 3
printf "%s: %-80s\n" "sandbox" "Starting data nodes on $hostname ..."
if [ "${initial}" = "1" ]; then
       printf "%s: %-80s\n" "Cluster" "Initial Cluster Start"
      bash ./start-ndbd-localhost-id-2.sh --initial --nowait
      bash ./start-ndbd-localhost-id-3.sh --initial --nowait
else
       printf "%s: %-80s\n" "Cluster" "Cluster Start"
      bash ./start-ndbd-localhost-id-2.sh --nowait
      bash ./start-ndbd-localhost-id-3.sh --nowait
fi
printf "%s: %-80s\n" "sandbox" "Waiting for cluster to start..."
for i in 1 2 3 4 5 6
do
   printf  "."
   sleep 1
done
   printf  "\n"
$bindir/ndb_mgm -c "localhost:1186"  -e show
printf "%s: %-80s\n" "sandbox" "Data nodes are starting. This can take a few minutes..."
$bindir/ndb_waiter -c "localhost:1186"  > /dev/null
$bindir/ndb_mgm -c "localhost:1186"  -e show
for i in 1 2 3 4 5
do
   printf  "."
   sleep 1
done
printf  "\n"
printf "%s: %-80s\n" "sandbox" "Starting the MySQL servers ..."
printf "%s: %-80s\n" "sandbox" "Starting mysqld server (one of two) ..."
$libexec/mysqld --defaults-file=$mycnf1 --datadir=$mysql_datadir1 --basedir=$basedir --user=$LOGNAME &
sleep 1
printf "%s: %-80s\n" "sandbox" "Starting mysqld server (two of two) ..."
$libexec/mysqld --defaults-file=$mycnf2 --datadir=$mysql_datadir2 --basedir=$basedir --user=$LOGNAME &
for i in 1 2 3 4 5
do
   printf  "."
   sleep 1
done
printf  "\n"
$bindir/ndb_mgm -c "localhost:1186"  -e show
sleep 1
printf "%s: %-80s\n" "sandbox" "Cluster is started"
exit;
