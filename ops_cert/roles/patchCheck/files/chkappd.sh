#!/bin/bash
# Last modified: Wed Jan 20 13:37:16 EST 2021

# dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,Benny.Butler@navihealth.com,Chad.Binkley@navihealth.com
export dist_list=jeffrey.ames@wellsky.com
export dist_list=Nima.Sherpa@wellsky.com

ts=`date`
cd /tmp
os1=`uname -r | awk -F\el '{print $2}' | awk -F\. '{print $1}'`
# echo "$ts OS is `uname -a` " > /tmp/filbeat.log
os1=`uname -r`

service_to_chk=appdynamics
service_name=appdynamics

Cim_pid=`ps -ef | grep Cim | grep opt | awk '{print $2}'`

#if [[ $os1 == 7 ]]
#then
#  systemctl stop $service_to_chk
#else
#  service $service_to_chk stop
#fi

#yum remove $service_to_chk -y
#systemctl disable $service_to_chk

if [[ $os1 == 7 ]]
then
  service_chk=`ps -ef | grep $service_to_chk | grep opt | awk '{print $2}'`
  if [[ $service_chk -eq 1 ]]
      then
        # echo " it's running do nothing"
        ps -ef | grep beats >> /tmp/filbeat.log
        echo -e "\n server: `hostname` \n OS is $os1 \n $service_name service IS running!! " | /bin/mail -s "Server: `hostname` $service_name running... os is $os1 " $dist_list
      else
        echo -e "\n server: `hostname` \n OS is $os1 \n  $service_name service IS NOT running!! " | /bin/mail -s "Server: `hostname` $service_name NOT running... os is $os1 " $dist_list
    fi
else
  service_chk=`ps -ef | grep $service_to_chk | grep opt | awk '{print $2}'`
  if [[ $service_chk -eq 1 ]]
     then
        echo -e "\n server: `hostname` \n OS is $os1 \n $service_name service IS running!!  " | /bin/mail -s "Server: `hostname` $service_name running... os is $os1 " $dist_list
    else
        echo -e "\n server: `hostname` \n OS is $os1 \n $service_name service IS NOT running!!  " | /bin/mail -s "Server: `hostname` $service_name NOT running... os is $os1 " $dist_list
  fi
fi
}


exit
