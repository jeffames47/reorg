#!/bin/bash
# Last modified: Thu Feb  9 10:17:18 EST 2023
#export dist_list=jeffrey.ames@wellsky.com,Nima.Sherpa@wellsky.com
export dist_list=jeffrey.ames@wellsky.com

service=$1
DEBUG=$2
service=Tanium
hst=`hostname`

pid_count=$(ps -ef | egrep $service | egrep -v grep | wc -l)
pid=$(ps -ef | egrep $service | awk '{print $2}')
##service_chk_centos_wc=`ps -ef | grep $service | grep -v grep | wc -l`

#if [[ $(which sshpass | wc -l) -ne 1 ]]
#  then yum install sshpass -y
#else
#  sleep 1
#fi

#if [[ $(which mailx | wc -l) -ne 1 ]]
#  then yum install mailx -y
#else
#  sleep 1
#fi

export os1=$(grep -Eo '[0-9]{1,4}' /etc/redhat-release|head -n1)

if [[ $os1 == 7 ]]
then
    #service_chk_wc=`systemctl status $service | grep active | grep running | wc -l`
    service_chk_wc=`ps -ef | grep $service | grep -v grep | wc -l`
else
    #service_chk_wc=`service $service status | grep running | wc -l`
    service_chk_wc=`ps -ef | grep $service | grep -v grep | wc -l`
fi

echo " \n service_chk_wc $service_chk_wc"

#if [[ $service_chk_wc == 0 ]]
if [[ $service_chk_wc -lt 4 ]]
  then
    echo -e "\n Service $service is down."
#    echo -e "\n ptt1 Service $service is down." | /bin/mail -s " `date +%m%d%y%H%M` Server: $hst Service $service is down. " $dist_list
    echo "`hostname` down $service " > tmp_status_DOWN_`hostname`$service
    sshpass -p 'Nav1Automation2018' scp -o StrictHostKeyChecking=no tmp_status_DOWN_`hostname`$service ansible@10.10.120.199:/tmp
  else
    echo -e "\n Service $service is UP !!!  "
#    echo -e "\n ptt2 Service $service is UP !!!  " | /bin/mail -s " 'YES' `date +%m%d%y%H%M` Server: $hst Service $service is UP !!! " $dist_list
    echo "`hostname` up $service " > tmp_status_UP_`hostname`$service
    sshpass -p 'Nav1Automation2018' scp -o StrictHostKeyChecking=no tmp_status_UP_`hostname`$service ansible@10.10.120.199:/tmp
fi
