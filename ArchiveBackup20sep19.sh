#!/bin/sh
#############################################################################
##ScriptName:-archive-backup.sh
##Description :- This Script will call defined archive server and take backup
##Modified By:-Ravindra Kudache
##Date:-16-09-2019
#############################################################################
BATDIR=/home/system-backup
LOGDIR=/home/system-backup/log

LOADER=/dev/sg4
TAPEDEV=/dev/nst0
DAY=`date +%d`
SLOT=`date +%w`
TMS=`date "+%H:%M:%S"`
if [ $SLOT = 0 ];then
 SLOT=7
fi

SLOT=`expr $SLOT + 8`

archive_process()
{
BATDIR=/home/system-backup
LOGDIR=/home/system-backup/log
i=$1
echo "=========================Processing on $i ================================"  >> $LOGDIR/remote-archive.$DAY.log 2>&1
ssh  $i  $BATDIR/archive-backup.sh $DAY >> $LOGDIR/remote-archive.$DAY.log 2>&1
if [ $? -eq 0 ]
then
echo "$i  server archive-backup.sh script run succesfully  " >> $LOGDIR/remote-archive.$DAY.log 2>&1
sleep 15

else

echo "$i Server unable to connect or  failure in  archive-backup.sh script run " >> $LOGDIR/remote-archive.$DAY.log 2>&1
#(echo "Subject: Health check up before Archive Log Backup - $i  - <<hkcgsoldb>> - $DAY"; echo "Status: Error on backup"; echo; cat $LOGDIR/remote-archive.$DAY.log) | /usr/lib/sendmail -f alert@globalsources.com ahu@globalsources.com ericlee@globalsources.com manchi@globalsources.com cbhon@globalsources.com IS-OSS-GS-Monitoring@Mphasis.com IS-OSS-GS-Backup@mphasis.com mphasissdp@service-now.com



fi
}

echo "================== Archive start $TMS ==========================================" > $LOGDIR/remote-archive.$DAY.log 2>&1
echo " " >> $LOGDIR/remote-archive.$DAY.log 2>&1
echo "====================Loading tape============================================="  >> $LOGDIR/remote-archive.$DAY.log 2>&1

#/usr/bin/sudo /usr/sbin/mtx -f $LOADER load $SLOT 0 > $LOGDIR/remote-archive.$DAY.log 2>&1

echo " " >> $LOGDIR/remote-archive.$DAY.log 2>&1

echo "=====================Health check up of master==========================">> $LOGDIR/remote-archive.$DAY.log 2>&1
echo "Pre-Checking ssh services in Master server   " >> $LOGDIR/remote-archive.$DAY.log 2>&1
#Validating ssh service running
service  sshd status|grep running >> $LOGDIR/remote-archive.$DAY.log 2>&1
if [ $? -eq 0 ]
then

echo "ssh service running state in Master Server  " >> $LOGDIR/remote-archive.$DAY.log 2>&1

echo "====================Start processing on backup server========================= " >> $LOGDIR/remote-archive.$DAY.log 2>&1

for hst in hkcgsoldb1
do
echo "========================Health check of $hst ==================================" >>  $LOGDIR/remote-archive.$DAY.log 2>&1

username=`whoami`
ExpDate=`ssh  $hst "chage -l ravi|grep 'Account expires' |cut -d: -f2"`  2>>  $LOGDIR/remote-archive.$DAY.log
if [ $? -eq 0 ]
then
ExpDateSec=`date -d "$ExpDate" +%s`
TodayDate=`ssh  $hst 'date   "+%b %d %Y"'`
TodayDateSec=`date -d "$TodayDate" +%s`
DiffSec=`expr $ExpDateSec -  $TodayDateSec `
DayRem=`expr  $DiffSec / 86400 `
echo "hostname = $hst "      >>  $LOGDIR/remote-archive.$DAY.log 2>&1
echo "Expery Date = $ExpDate" >>  $LOGDIR/remote-archive.$DAY.log 2>&1
echo "Day Reaming for expires $DayRem " >>  $LOGDIR/remote-archive.$DAY.log 2>&1
if [ $DayRem -lt 0 ]
then
#(echo "Subject: Health check up :- $username is  expired already   and   Expery date is $ExpDate   in  $hst host - $hst  - <<hkcgsoldb>> - $DAY"; echo "Status: Error on backup"; echo; cat $LOGDIR/remote-archive.$DAY.log) | /usr/lib/sendmail -f alert@globalsources.com ahu@globalsources.com ericlee@globalsources.com manchi@globalsources.com cbhon@globalsources.com IS-OSS-GS-Monitoring@Mphasis.com IS-OSS-GS-Backup@mphasis.com mphasissdp@service-now.com
echo "Health check up :- $username account is  expired already   and   Expery date is $ExpDate   in  $hst host" >> $LOGDIR/remote-archive.$DAY.log 2>&1
elif [[ $DayRem -gt 0 ]] && [[ $DayRem -lt 2 ]]
then
#(echo "Subject: Health check up :- $username account will expery in $DayRem dayes and   Expery date is $ExpDate   in  $hst hosts - $hst  - <<hkcgsoldb>> - $DAY"; echo "Status: Error on backup"; echo; cat $LOGDIR/remote-archive.$DAY.log) | /usr/lib/sendmail -f alert@globalsources.com ahu@globalsources.com ericlee@globalsources.com manchi@globalsources.com cbhon@globalsources.com IS-OSS-GS-Monitoring@Mphasis.com IS-OSS-GS-Backup@mphasis.com mphasissdp@service-now.com
echo "Health check up :- $username account will expery in $DayRem dayes and   Expery date is $ExpDate   in  $hst hosts" >> $LOGDIR/remote-archive.$DAY.log 2>&1




archive_process $hst



else
echo "Health check up :- $username account will expery in $DayRem dayes and   Expery date is $ExpDate   in  $hst hosts" >> $LOGDIR/remote-archive.$DAY.log 2>&1

archive_process $hst
fi
else
echo " Health check up :- $hst Server unable to connect  " >> $LOGDIR/remote-archive.$DAY.log 2>&1
#(echo "Subject: Health check up :- $hst Server unable to connect   - $i  - <<hkcgsoldb>> - $DAY"; echo "Status: Error on backup"; echo; cat $LOGDIR/remote-archive.$DAY.log) | /usr/lib/sendmail -f alert@globalsources.com ahu@globalsources.com ericlee@globalsources.com manchi@globalsources.com cbhon@globalsources.com IS-OSS-GS-Monitoring@Mphasis.com IS-OSS-GS-Backup@mphasis.com mphasissdp@service-now.com
fi

done

sleep 15

else
echo "ssh service is in stoped state  Please start service  in master " >> $LOGDIR/remote-archive.$DAY.log 2>&1
#(echo "Subject: Health check up :- service ssh has been stoped staate in master server   - $hst  - <<hkcgsoldb>> - $DAY"; echo "Status: Error on backup"; echo; cat $LOGDIR/remote-archive.$DAY.log) | /usr/lib/sendmail -f alert@globalsources.com ahu@globalsources.com ericlee@globalsources.com manchi@globalsources.com cbhon@globalsources.com IS-OSS-GS-Monitoring@Mphasis.com IS-OSS-GS-Backup@mphasis.com mphasissdp@service-now.com

fi

echo "=====================Archive-backup processs has been completed for all server =============== ">> $LOGDIR/remote-archive.$DAY.log 2>&1

echo "========================Start rewind tape =========================">> $LOGDIR/remote-archive.$DAY.log 2>&1
#mt -f $TAPEDEV rewind >> $LOGDIR/remote-archive.$DAY.log 2>&1
#sleep 60

echo "========================Start Processing on archive-verify.sh script=========================">> $LOGDIR/remote-archive.$DAY.log 2>&1

#ssh hkcgsoldb   $BATDIR/archive-verify.sh $DAY >> $LOGDIR/remote-archive.$DAY.log 2>&1
#sleep 15
#ssh hkpscdb     $BATDIR/archive-verify.sh $DAY >> $LOGDIR/remote-archive.$DAY.log 2>&1
#sleep 15
#ssh hkgsoldb    $BATDIR/archive-verify.sh $DAY >> $LOGDIR/remote-archive.$DAY.log 2>&1
#sleep 15
#ssh hkmsgctrdb  $BATDIR/archive-verify.sh $DAY >> $LOGDIR/remote-archive.$DAY.log 2>&1
#sleep 15
#ssh hkisysdb    $BATDIR/archive-verify.sh $DAY >> $LOGDIR/remote-archive.$DAY.log 2>&1
#sleep 15
#ssh hkfindb     $BATDIR/archive-verify.sh $DAY >> $LOGDIR/remote-archive.$DAY.log 2>&1
#sleep 15

echo "========================Unload tape script=========================">> $LOGDIR/remote-archive.$DAY.log 2>&1

#/usr/bin/sudo /usr/sbin/mtx -f $LOADER unload $SLOT 0 >> $LOGDIR/remote-archive.$DAY.log 2>&1
sleep 15

TME=`date "+%H:%M:%S"`
echo "================== Archive end $TME ==========================================" >> $LOGDIR/remote-archive.$DAY.log 2>&1

#(echo "Subject:  archive-backup.sh script completed in  `hostname`  $DAY"; echo "Status:archive-backup.sh script completed "; echo; cat $LOGDIR/remote-archive.$DAY.log) | /usr/lib/sendmail -f  ahu@globalsources.com ericlee@globalsources.com manchi@globalsources.com cbhon@globalsources.com IS-OSS-GS-Monitoring@Mphasis.com IS-OSS-GS-Backup@mphasis.com mphasissdp@service-now.com

