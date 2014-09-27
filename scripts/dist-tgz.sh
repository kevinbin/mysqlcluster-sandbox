tput sc
installdir=`pwd`/../install/
hostnames="localhost"
fullname=$1
fname=`basename $fullname`
realname=`echo "$fname" | awk -F ".tar"  '{print $1}'`
if [ -n "$fullname" ]; then
	echo ""
	else
	echo "syntax: dist-tgz.sh  /home/xyz/mysql-cluster-gpl-6.3.17-linux-i686-glibc23.tar.gz "
	echo "It must be a tgz and it must NOT be placed in /tmp "
	exit;
fi
printf "%s: %-80s" "sandbox" "Installing on localhost";tput el;tput rc
rm -rf $installdir/mysql
mkdir -p $installdir
printf "%s: %-80s" "sandbox" "Copying files...";tput el;tput rc
cp $fullname /tmp
printf "%s: %-80s" "sandbox" "unpacking...";tput el;tput rc
zcat /tmp/$fname | tar xf - -C $installdir;tput el;tput rc
printf "%s: %-80s" "sandbox" "cleaning up...";tput el;tput rc
rm  /tmp/$fname
printf "%s: %-80s" "sandbox" "setting up symlink mysql->mysql-XYZ...";tput el;tput rc
ln -s $installdir/$realname $installdir/mysql
printf "%s: %-80s" "sandbox" "Installing of binaries is complete";tput el;
printf "\n%s: %-80s\n" "sandbox" "Binaries are installed in $installdir"
printf "Do you want to run bootstrap.sh now (recommended) or do it later? (y/n):"
read answer
if [ "$answer" == "y" ]; then
    bash ./bootstrap.sh
else
    exit
fi
printf "Do you want to run start-cluster.sh --initial now (recommended) or do it later? (y/n):"
read answer
if [ "$answer" == "y" ]; then
    bash ./start-cluster.sh --initial
    exit
fi
