#!/bin/bash
ftphost="52.179.14.224"
ftpuser="adminuser"
read -sp "Enter user password: " ftppass
dt=`date +%Y%m%d`
ftpfile="vip${dt}"

while [ 1 == 1 ]
do

ftp -n ${ftphost}<<EOF>ftpopt
quote USER ${ftpuser}
quote pass ${ftppass}
bin
ls

EOF

echo "Validating file present or not"

echo "File present downloading now"

grep ${ftpfile} ftpopt >/dev/null
if [ $? == 0 ]
then
ftp -n ${ftphost}<<EOF1>>ftpopt
quote USER ${ftpuser}
quote pass ${ftppass}
bin
get ${ftpfile}
EOF1
echo "Download is completed"
exit
else
echo "File is not present"
sleep 10
fi


done

