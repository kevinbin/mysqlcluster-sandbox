#!/bin/bash
TEMP=`getopt -oh,f,i,n --long ignore,initial,help,nowait -n 'start-ndbd-localhost-id-<id>.sh' -- "$@"`
eval set -- "$TEMP"
tput init
help=""
initial=""
ignore="0"
nowait=""
while true ; do
   case "$1" in
      -i|--initial) initial="1" ; shift ;;
      -f|--ignore) ignore="1" ; shift ;;
      -n|--nowait) nowait="1" ; shift ;;
      -h|--help) help="1" ; shift ;;
      --) shift ; break ;;
      *) echo "Internal error!" ; exit 1 ;;
   esac
done
if [ "${help}" = "1" ]; then
  echo "usage: ./start-ndbd-localhost-id-<id>.sh [-i|--initial] [-n|--nowait]"
  echo "-n|--nowait -- script starts node and returns immediately"
  echo "-i|--initial -- initial start of data node (clears local file system)"
  echo "-f|--ignore -- ignore wait for communication opened event (ignored in sandbox)"
  exit
fi
localconfigpath=`pwd`/../config
configini=$localconfigpath/config.ini
connectstring="localhost:1186"
bindir=`pwd`/../install//mysql/bin/
libexec=`pwd`/../install//mysql/bin/
hostname="localhost"
if [ "${initial}" = "1" ]; then
       printf "%s: %-80s\n" "sandbox" "Starting data node (nodeid=3) - initial node start"
      $libexec/ndbd --ndb-nodeid=3 -c "localhost:1186" --initial
else
       printf "%s: %-80s\n" "sandbox" "Starting data node (nodeid=$id)"
      $libexec/ndbd --ndb-nodeid=3 -c "localhost:1186"
fi
printf "%s: %-80s\n" "sandbox" "Data node 3 is STARTING"
if [ "${nowait}" = "1" ]; 
then 
   exit; 
fi
st=""

while true
do
   sleep 1
   st=`$bindir/ndb_mgm -c "$connectstring" -e "3 STATUS" |grep "Node 3: started"`
   if [ "${st}" != "" ]; 
   then
             break;
   else
             printf "."
   fi
done
printf "\n"
printf "%s: %-80s\n" "sandbox" "Data node 3 is STARTED"
$bindir/ndb_waiter -c "localhost:1186"  > /dev/null
bash show.sh

exit

