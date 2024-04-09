#!/bin/bash
# Last modified:  2/9/23
# dist_list=operations@navihealth.com
# dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,Benny.Butler@navihealth.com,Chad.Binkley@navihealth.com
# dist_list=jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,bruce.jackson@navihealth.com
  export dist_list=jeffrey.ames@wellsky.com

service_to_chk=splunk
service_name=splunk
service=splunk

export IP=$1
export env=$2

  service_chk=`cat /opt/splunkforwarder/etc/system/local/deploymentclient.conf | grep $IP | wc -l`

  if [[ $service_chk == 2 || $service_chk == 1 || $service_chk -gt 0 ]]
  then
     echo "`hostname` up $service " > tmp_status_UP_`hostname`$service_name
     sshpass -p 'Nav1Automation2018' scp -o StrictHostKeyChecking=no tmp_status_UP_`hostname`$service ansible@10.10.120.199:/tmp
     echo -e "\n server: `hostname` \n $service_name service UP!! " | /bin/mail -s " `date +%m%d%y%H%M` $service_name installed on Server: `hostname` $service_name service is UP " $dist_list
   else
     echo "`hostname` down $service " > tmp_status_DOWN_`hostname`$service_name
     sshpass -p 'Nav1Automation2018' scp -o StrictHostKeyChecking=no tmp_status_DOWN_`hostname`$service ansible@10.10.120.199:/tmp
     echo -e "\n server: `hostname` \n $service_name service DOWN!! " | /bin/mail -s " `date +%m%d%y%H%M` Server: `hostname` $service_name service DOWN... Please investigate. " $dist_list
    fi

#rm -rf /tmp/tmp_status*
#rm -rf /usr/local/tmp_status*

