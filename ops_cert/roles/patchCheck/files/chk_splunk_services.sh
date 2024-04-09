#!/bin/bash

# dist_list=jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,Benny.Butler@navihealth.com,Chad.Binkley@navihealth.com
export dist_list=jeffrey.ames@navihealth.com
export dist_list=jeffrey.ames@navihealth.com,david.martin@navihealth.com,richard.gu@navihealth.com,mohan.Shrestha@navihealth.com,gary.potagal@navihealth.com
 export dist_list=jeffrey.ames@navihealth.com,nima.sherpa@navihealth.com
########  dist_list=jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,bruce.jackson@navihealth.com
 export dist_list=jeffrey.ames@navihealth.com

service=$1
DEBUG=$2

pid_coun=t$(ps -ef | egrep $service | egrep -v grep | wc -l)
pid=$(ps -ef | egrep $service | awk '{print $2}')
service_chk_centos6_wc=`ps -ef | grep $service | grep -v grep | wc -l`

export os1=$(grep -Eo '[0-9]{1,4}' /etc/redhat-release|head -n1)

service_chk_wc=`ps -ef | grep splunk |  egrep -v grep | wc -l`

hst=`hostname`
if [[ $service_chk_wc == 0 ]]
  then
    echo -e "\n Service $service is down." | /bin/mail -s " 'WARNING' `date +"%T"` `date +"%m-%d-%y" ` Server: $hst Service $service is down. " $dist_list
  else
    echo -e "\n Service $service is UP !!!  " | /bin/mail -s " 'YES'  `date +"%T"` `date +"%m-%d-%y" ` Server: $hst Service $service is UP !!! " $dist_list
fi

exit

