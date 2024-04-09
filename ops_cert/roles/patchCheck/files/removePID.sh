#!/bin/bash
# Last modified: Thu Jan 21 13:37:16 EST 2021

# dist_list=operations@navihealth.com
# dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,Benny.Butler@navihealth.com,Chad.Binkley@navihealth.com
# dist_list=jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,bruce.jackson@navihealth.com
  export dist_list=jeffrey.ames@wellsky.com

cd /tmp
os1=`uname -r | awk -F\el '{print $2}' | awk -F\. '{print $1}'`
# echo "$ts OS is `uname -a` " > /tmp/filbeat.log
os1=`uname -r`

service_to_chk=$1
service_to_chk2=$1
service_name=$1

#yum remove swiagent

if [[ $os1 == 7 ]]
then
  systemctl stop $service_to_chk
  systemctl stop $service_to_chk2
else
  service $service_to_chk stop
  service $service_to_chk2 stop
fi

yum remove $service_to_chk -y

rm -Rf /opt/$service_to_chk2

systemctl disable $service_to_chk

pid1=`ps -ef | grep $service_to_chk | grep -v grep | awk '{print $2}'`
kill -9 $pid1 ; sleep 1

pid2=`ps -ef | grep $service_to_chk | grep -v grep | awk '{print $2}'`
kill -9 $pid2 ; sleep 1

if [[ $pid1 -gt 1 ]]
# if [[ $pid == 0 ]]
    then
      # echo " it's running do nothing"
      ps -ef | grep beats >> /tmp/filbeat.log 
      echo -e "\n server: `hostname` \n OS is $os1 \n $service_name service IS running!! " | /bin/mail -s "Server: `hostname` $service_name running... os is $os1 " $dist_list
    else
      echo -e "\n server: `hostname` \n OS is $os1 \n  $service_name service IS NOT running!! " | /bin/mail -s "Server: `hostname` $service_name NOT running... os is $os1 " $dist_list
fi

exit
