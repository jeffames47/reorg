#!/bin/bash
# Last modified: Fri Jan 20 13:37:16 EST 2023

# dist_list=operations@navihealth.com
# dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,Benny.Butler@navihealth.com,Chad.Binkley@navihealth.com
#  export dist_list=jeffrey.ames@navihealth.com,david.martin@navihealth.com,gary.potagal@navihealth.com
  export dist_list=jeffrey.ames@wellsky.com

os1=`uname -r | awk -F\el '{print $2}' | awk -F\. '{print $1}'`
# echo "$ts OS is `uname -a` " > /tmp/filbeat.log
os1=`uname -r`

export service=Tanium

if [[ $(which sshpass | wc -l) -ne 1 ]]
  then yum install sshpass -y
else
  sleep 1
fi

systemctl disable taniumclient
systemctl stop taniumclient
rm -rf /opt/Tanium
yum remove TaniumClient.x86_64 -y
rm -Rf /var/lock/subsys/TaniumClient

if [[ $os1 == 7 ]]
then
    service_chk_wc=`systemctl status $service | grep active | grep running | wc -l`
else
    service_chk_wc=`service $service status | grep running | wc -l`
fi

if [[ $service_chk_wc == 0 ]]
  then
    sh -c "false; exit 0" ; echo $?
#    echo -e "\n Service $service is down." | /bin/mail -s " 'WARNING' `date +%m%d%y%H%M` Server: $hst Service $service is down. " $dist_list
  else
    sh -c "false" ; echo $?
#    echo -e "\n Service $service is UP !!!  " | /bin/mail -s " 'YES' `date +%m%d%y%H%M` Server: $hst Service $service is UP !!! " $dist_list
fi

if [[ $service_chk_wc == 0 ]]
  then
     echo "`hostname` down $service " > tmp_status_DOWN_`hostname`$service
     sshpass -p 'Nav1Automation2018' scp -o StrictHostKeyChecking=no tmp_status_DOWN_`hostname`$service ansible@10.10.120.199:/tmp
  else
     echo "`hostname` up $service " > tmp_status_UP_`hostname`$service
     sshpass -p 'Nav1Automation2018' scp -o StrictHostKeyChecking=no tmp_status_UP_`hostname`$service ansible@10.10.120.199:/tmp
fi

rm -rf /tmp/tmp_status*
rm -rf /usr/local/tmp_status*

if [[ $os1 == 7 ]]
then
  service_to_chk=Tanium
  service_name=taniumclient.service
  systemctl stop taniumclient.service
  systemctl disable taniumclient
 else
  service_to_chk=Tanium
  service_name=taniumclient.service
  service taniumclient.service stop 
  service taniumclient.service disable
fi

#service_chk=`ps -ef | grep $service_to_chk | grep -v grep | wc -l`
## if [[ $service_chk -ge 1 ]]
## if [[ $service_chk_wc -lt 3 ]]
#if [[ $service_chk_wc == lt 0 || $service_chk_wc == lt 1 || $service_chk_wc == lt 2 ]]
#     then
#        echo -e "\n server: `hostname` \n OS is $os1 \n $service_to_chk service IS running!! " | /bin/mail -s "Server: `hostname` $service_to_chk IS running... os is $os1 " $dist_list
#     else
#       echo -e "\n server: `hostname` \n OS is $os1 \n  $service_to_chk service IS NOT running!! " | /bin/mail -s "Server: `hostname` $service_to_chk NOT running... os is $os1 " $dist_list
#fi

exit 
