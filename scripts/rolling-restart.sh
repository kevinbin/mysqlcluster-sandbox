#!/bin/bash
TEMP=`getopt -oi,h --long initial,help: -n 'rolling-restart.sh' -- "$@"`
eval set -- "$TEMP"
help=""
initial=""
layer="all"
while true ; do
   case "$1" in
      -i|--initial) initial="1" ; shift ;;
      -h|--help) help="1" ; shift ;;
      --) shift ; break ;;
      *) echo "Internal error!" ; exit 1 ;;
   esac
done
if [ "${help}" = "1" ]; then
  echo "usage: ./rolling-restart.sh [-i|--initial]"
  echo "-i|--initial -- Rolling restart of cluster (each data node will clear out its data and resync one at time)"
  exit
fi
tput init
tput sc
localconfigpath=`pwd`/../config
configini=$localconfigpath/config.ini
mycnf1=../config/my.cnf.1
mycnf2=../config/my.cnf.2
connectstring="localhost:1186"
ndbd_datadir=`pwd`/../datadir/
mgmd_datadir=`pwd`/../datadir/
hostnames=""
installdir=`pwd`/../install/
bindir=$installdir/mysql/bin/

libexec=$installdir/mysql/bin/

printf "%s: %-80s\n" "sandbox" "Terminating management server ..."
killall -15 ndb_mgmd
sleep 2
killall -9 ndb_mgmd
sleep 1
if [ "${initial}" = "1" ]; then
       printf "%s: %-80s\n" "sandbox" "Rolling Restart (initial)"
else
       printf "%s: %-80s\n" "sandbox" "Rolling Restart"
fi
printf "%s: %-80s\n" "sandbox" "Starting management server on $host ..."
$libexec/ndb_mgmd -c "$host"  -f $configini --configdir=$localconfigpath --reload --initial
printf "%s: %-80s\n" "sandbox" "Sleeping for three seconds"
for i in 1 2 3
do
   printf  "."
   sleep 1
done
printf  "\n"
ndbd_ids=`$bindir/ndb_config --ndb-connectstring="localhost:1186" --config-file=$configini --query=id  --type=ndbd`
for id in $ndbd_ids
do
	printf "%s: %-80s\n" "sandbox" "Restarting data node with id=$id out of $ndbd_ids..."
	bash ./stop-ndbd-localhost-id-$id.sh
	printf "%s: %-80s\n" "sandbox" "Waiting 5 seconds before restarting data node..."
	for i in 1 2 3 4 5
	do
	   printf  "."
	   sleep 1
	done
	printf  "\n"
	printf "%s: %-80s\n" "sandbox" "Restarting data node..."
      if [ "${initial}" = "1" ]; then
          bash ./start-ndbd-localhost-id-$id.sh --initial
      else
          bash ./start-ndbd-localhost-id-$id.sh
      fi
done
printf "%s: %-80s\n" "sandbox" "Data nodes are restarted..."
printf "%s: %-80s\n" "sandbox" "Restarting MySQL servers..."
sleep 2
printf "%s: %-80s\n" "sandbox" "Stopping mysqld server 1 on localhost..."
bash ./stop-mysqld-localhost-1.sh > /tmp/restart.log
for i in 1 2 3
do
   printf  "."
   sleep 1
done
printf  "\n"
printf "%s: %-80s\n" "sandbox" "Starting mysqld server 1 on localhost ..."
bash ./start-mysqld-localhost-1.sh > /tmp/restart.log
printf "%s: %-80s\n" "sandbox" "Stopping mysqld server 2 on localhost ..."
bash ./stop-mysqld-localhost-2.sh > /tmp/restart.log
for i in 1 2 3
do
   printf  "."
   sleep 1
done
printf  "\n"
printf "%s: %-80s\n" "sandbox" "Starting mysqld server 2 on localhost ..."
bash ./start-mysqld-localhost-2.sh > /tmp/restart.log
for i in 1 2 3
do
   printf  "."
   sleep 1
done
printf  "\n"
$bindir/ndb_mgm -c "localhost:1186"  -e show
printf "%s: %-80s\n" "sandbox" "Cluster has performed rolling restart"
exit;