#!/bin/bash
# Last modified: Wed Jan 20 13:37:16 EST 2021

# dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,Benny.Butler@navihealth.com,Chad.Binkley@navihealth.com
export dist_list=jeffrey.ames@wellsky.com

ts=`date`
cd /tmp
os1=`uname -r`

service=swiagent
service2=SolarWinds
DEBUG=$3

pid=$(ps -ef | egrep $service | grep -v grep| awk '{print $2}')
pid2=$(ps -ef | egrep $service2 | grep -v grep| awk '{print $2}')
service_chk_centos6_wc=`ps -ef | grep $service2 | grep -v grep | wc -l`

echo " pid $pid"
echo " pid2 $pid2"

#if [[ $os1 == 7 ]]
#then
#  systemctl stop $service_to_chk
#else
#  service $service_to_chk stop
#fi

#yum remove $service_to_chk -y
#systemctl disable $service_to_chk

if [[ $pid -gt 1 ]]
# if [[ $pid == 0 ]]
then
     echo " it's running "
     echo -e "\n server: `hostname` \n OS is $os1 \n $service_name service IS running!! " | /bin/mail -s "Server: `hostname` $service_name running... os is $os1 " $dist_list
  else
     echo -e "\n server: `hostname` \n OS is $os1 \n  $service_name service IS NOT running!! " | /bin/mail -s "Server: `hostname` $service_name NOT running... os is $os1 " $dist_list
fi
}

