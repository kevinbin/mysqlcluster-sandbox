#!/bin/bash
connectstring="localhost:1186"
installdir=`pwd`/../install/
bindir=$installdir/mysql/bin/
libexec=$installdir/mysql/bin/
datadir=`pwd`/../datadir/

st=""

$bindir/ndb_mgm -c "localhost:1186"  -e "3 stop -a"
while true
do
   sleep 1
   st=`$bindir/ndb_mgm -c "$connectstring" -e "3 STATUS" |grep "Node 3: not connected"`
   if [ "${st}" != "" ]; 
   then
         break;
   else
         printf "."
   fi
done
printf "\n"
printf "%s: %-80s\n" "sandbox" "Data node 3 has STOPPED"
sleep 2

bash show.sh

