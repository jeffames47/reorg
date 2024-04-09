#!/bin/bash
# Last modified: Thu Jan 21 13:37:16 EST 2021

# dist_list=operations@navihealth.com
# dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,Benny.Butler@navihealth.com,Chad.Binkley@navihealth.com
# dist_list=jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,bruce.jackson@navihealth.com
  export dist_list=jeffrey.ames@wellsky.com

######## Submodules:

##############################################################
# This function will check a service and run it if it is down
##############################################################
kill_pid () {

SW_pid=`ps -ef | grep $service_to_chk | grep -v grep | awk '{print $2}'`
kill -9 $SW_pid ; sleep 1

SW_pid2=`ps -ef | grep $service_to_chk | grep -v grep | awk '{print $2}'`
kill -9 $SW_pid2 ; sleep 1

}


##############################################################
#                         MAIN
##############################################################

cd /tmp
os1=`uname -r | awk -F\el '{print $2}' | awk -F\. '{print $1}'`
# echo "$ts OS is `uname -a` " > /tmp/filbeat.log
os1=`uname -r`

service_to_chk=nessusd
service_to_chk2=nessus-service
kill_pid

service_to_chk=nessus
service_to_chk2=nessus-agent-module
kill_pid

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

SW_pid=`ps -ef | grep $service_to_chk | grep -v grep | awk '{print $2}'`
kill -9 $SW_pid ; sleep 1

SW_pid2=`ps -ef | grep $service_to_chk | grep -v grep | awk '{print $2}'`
kill -9 $SW_pid2 ; sleep 1

if [[ $SW_pid -gt 1 ]]
# if [[ $SW_pid == 0 ]]
    then
      # echo " it's running do nothing"
      ps -ef | grep beats >> /tmp/filbeat.log 
      echo -e "\n server: `hostname` \n OS is $os1 \n $service_to_chk service IS running!! " | /bin/mail -s "Server: `hostname` $service_to_chk running... os is $os1 " $dist_list
    else
      echo -e "\n server: `hostname` \n OS is $os1 \n  $service_to_chk service IS NOT running!! " | /bin/mail -s "Server: `hostname` $service_to_chk NOT running... os is $os1 " $dist_list
fi

exit