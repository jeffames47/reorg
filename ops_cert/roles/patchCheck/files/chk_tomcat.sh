#!/bin/bash
# Last modified: Wed Feb  8 08:58:27 CST 2023
########  dist_list=jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,bruce.jackson@navihealth.com
 export dist_list=jeffrey.ames@wellsky.com,luis.arce@wellsky.com,Roshni.Patel@careporthealth.com
 export dist_list=jeffrey.ames@wellsky.com,luis.arce@wellsky.com

export service=$1
DEBUG=$2

pid=$(ps -ef | egrep $service | awk '{print $2}')
service_chk_centos6_wc=`ps -ef | grep $service | grep -v grep | wc -l`
export os1=$(grep -Eo '[0-9]{1,4}' /etc/redhat-release|head -n1)

if [[ $(which sshpass | wc -l) -ne 1 ]]
  then yum install sshpass -y
else
  sleep 1
fi

if [[ $(which mailx | wc -l) -ne 1 ]]
  then yum install mailx -y
else
  sleep 1
fi

service_chk_wc=`/etc/init.d/tomcat8 status | grep running | wc -l`

hst=`hostname`

#if [[ $service_chk_wc == 0 ]]
#  then
#    echo -e "\n Service $service is down." | /bin/mail -s " 'WARNING' `date +%m%d%y%H%M` Server: $hst Service $service is down. " $dist_list
#  else
#    echo -e "\n Service $service is UP !!!  " | /bin/mail -s " 'YES' `date +%m%d%y%H%M` Server: $hst Service $service is UP !!! " $dist_list
#fi

if [[ $service_chk_wc == 0 ]]
  then
     #echo "`hostname` down $service " > tmp_status_DOWN_`hostname`$service
     echo "`hostname`_down_$service " > tmp_status_DOWN_`hostname`$service
#cp -f /tmp/tmp_status* /tmp/tmpstatustoremove
cat /tmp/tmp_status_* > /tmp/tmpstatustoremove
     sshpass -p 'Nav1Automation2018' scp -o StrictHostKeyChecking=no tmpstatustoremove ansible@10.10.120.199:/tmp 2> /dev/null
     sshpass -p 'Nav1Automation2018' scp -o StrictHostKeyChecking=no tmpstatustoremove`hostname`$service ansible@10.10.120.199:/tmp 2> /dev/null
     sshpass -p 'Nav1Automation2018' scp -o StrictHostKeyChecking=no tmp_status_DOWN_`hostname`$service ansible@10.10.130.90:/tmp 2> /dev/null
     sshpass -p 'Nav1Automation2018' scp -o StrictHostKeyChecking=no tmp_status_DOWN_`hostname`$service ansible@10.10.120.199:/tmp 2> /dev/null
     sshpass -p 'Nav1Automation2018' scp -o StrictHostKeyChecking=no tmpstatustoremove`hostname`$service ansible@10.10.130.190:/tmp 2> /dev/null
     sshpass -p 'Nav1Automation2018' scp -o StrictHostKeyChecking=no tmpstatustoremove ansible@10.10.130.190:/tmp 2> /dev/null
  else
     #echo "`hostname` up $service " > tmp_status_UP_`hostname`$service
     echo "`hostname`_up_$service " > tmp_status_UP_`hostname`$service
#cp -f /tmp/tmp_status* /tmp/tmpstatustoremove
cat /tmp/tmp_status_* > /tmp/tmpstatustoremove
     sshpass -p 'Nav1Automation2018' scp -o StrictHostKeyChecking=no tmpstatustoremove ansible@10.10.120.199:/tmp 2> /dev/null
     sshpass -p 'Nav1Automation2018' scp -o StrictHostKeyChecking=no tmpstatustoremove`hostname`$service ansible@10.10.120.199:/tmp 2> /dev/null
     sshpass -p 'Nav1Automation2018' scp -o StrictHostKeyChecking=no tmp_status_UP_`hostname`$service ansible@10.10.130.90:/tmp 2> /dev/null
     sshpass -p 'Nav1Automation2018' scp -o StrictHostKeyChecking=no tmp_status_UP_`hostname`$service ansible@10.10.120.199:/tmp 2> /dev/null
     sshpass -p 'Nav1Automation2018' scp -o StrictHostKeyChecking=no tmpstatustoremove`hostname`$service ansible@10.10.130.190:/tmp 2> /dev/null
     sshpass -p 'Nav1Automation2018' scp -o StrictHostKeyChecking=no tmpstatustoremove ansible@10.10.130.190:/tmp
fi

#rm -f /tmp/tmp_statu*
#rm -f /tmp/tmpstatusto*

exit
