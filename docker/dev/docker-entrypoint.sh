#!/bin/bash
#set -e

echo "* Setting up /usr/src links from host"

for i in $(ls $DIGWATCH_HOST_ROOT/usr/src)
do 
	ln -s $DIGWATCH_HOST_ROOT/usr/src/$i /usr/src/$i
done

/usr/bin/sysdig-probe-loader

exec "$@"
