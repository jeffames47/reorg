#!/bin/bash
# Last modified:  Sun Oct 17 09:57:26 EST 2021
# dist_list=jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,Benny.Butler@navihealth.com,bruce.jackson@navihealth.com
export dist_list=jeffrey.ames@wellsky.com

service=$1
DEBUG=$2
service=snow

pid_count=$(ps -ef | egrep $service | egrep -v grep | wc -l)
pid=$(ps -ef | egrep $service | awk '{print $2}')
##service_chk_centos_wc=`ps -ef | grep $service | grep -v grep | wc -l`

export os1=$(grep -Eo '[0-9]{1,4}' /etc/redhat-release|head -n1)

#if [[ $(which mailx | wc -l) -ne 1 ]]
#  then yum install mailx -y
#else
#  sleep 1
#fi

pid=$(ps -ef | egrep $service | awk '{print $2}')
service_chk_centos6_wc=`ps -ef | grep $service | grep -v grep | wc -l`
export os1=$(grep -Eo '[0-9]{1,4}' /etc/redhat-release|head -n1)

if [[ $(which sshpass | wc -l) -ne 1 ]]
  then yum install sshpass -y
else
  sleep 1
fi

if [[ $os1 == 7 ]]
then
    service_chk_wc=`systemctl status $service | grep active | grep running | wc -l`
else
    service_chk_wc=`service $service status | grep running | wc -l`
fi

hst=`hostname`

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

exit