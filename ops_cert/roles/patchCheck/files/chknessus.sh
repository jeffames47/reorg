#!/bin/bash
# Last modified:  2/9/23
# dist_list=operations@navihealth.com
# dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,Benny.Butler@navihealth.com,Chad.Binkley@navihealth.com
# dist_list=jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,bruce.jackson@navihealth.com
  # export dist_list=jeffrey.ames@wellsky.com
  export dist_list=nima.sherpa@careporthealth.com

service_to_chk=nessusagent.service
service_name=nessus
service=nessus

cd /opt/nessus_agent/sbin
service_chk_new=`./nessuscli agent status | grep Linked | grep 443`

if [[ $(which sshpass | wc -l) -ne 1 ]]
  then yum install sshpass -y
else
  sleep 1
fi

#if [[ $(which mailx | wc -l) -ne 1 ]]
#  then yum install mailx -y
#else
#  sleep 1
#fi

#if [[ "$service_chk_new" == "Linked to: cloud.tenable.com:443" ]]

service_chk=`systemctl status $service_to_chk | grep running | wc -l`
if [[ $service_chk -eq 1 ]]
  then
     echo "`hostname` up $service " > tmp_status_UP_`hostname`$service_name
     sshpass -p 'Nav1Automation2018' scp -o StrictHostKeyChecking=no tmp_status_UP_`hostname`$service ansible@10.10.120.199:/tmp
     echo -e "\n server: `hostname` \n $service_name service UP!! " | /bin/mail -s " `date +%m%d%y%H%M` $service_name installed on Server: `hostname` $service_name service is UP " $dist_list
   else
     echo "`hostname` down $service " > tmp_status_DOWN_`hostname`$service_name
     sshpass -p 'Nav1Automation2018' scp -o StrictHostKeyChecking=no tmp_status_DOWN_`hostname`$service ansible@10.10.120.199:/tmp
     echo -e "\n server: `hostname` \n $service_name service DOWN!! " | /bin/mail -s " `date +%m%d%y%H%M` Server: `hostname` $service_name service DOWN... Please investigate. " $dist_list
    fi

exit 


if [[ $os1 == 7 ]]
then
  service_chk=`systemctl status $service_to_chk | grep running | wc -l`
  if [[ $service_chk_new -eq 1 ]]
  then
     echo "`hostname` up $service " > tmp_status_UP_`hostname`$service
     sshpass -p 'Nav1Automation2018' scp -o StrictHostKeyChecking=no tmp_status_UP_`hostname`$service ansible@10.10.120.199:/tmp
     echo -e "\n server: `hostname` \n $service_name service UP!! " | /bin/mail -s " `date +%m%d%y%H%M` $service_name installed on Server: `hostname` $service_name service is UP " $dist_list
   else
     echo "`hostname` down $service " > tmp_status_DOWN_`hostname`$service
     sshpass -p 'Nav1Automation2018' scp -o StrictHostKeyChecking=no tmp_status_DOWN_`hostname`$service ansible@10.10.120.199:/tmp
     echo -e "\n server: `hostname` \n $service_name service DOWN!! " | /bin/mail -s " `date +%m%d%y%H%M` Server: `hostname` $service_name service DOWN... Please investigate. " $dist_list
    fi
else
  service_chk=`service $service_to_chk status | grep running | wc -l`
  if [[ $service_chk -eq 1 ]]
  then
     echo "`hostname` up $service " > tmp_status_UP_`hostname`$service
     sshpass -p 'Nav1Automation2018' scp -o StrictHostKeyChecking=no tmp_status_UP_`hostname`$service ansible@10.10.120.199:/tmp
     echo -e "\n server: `hostname` \n $service_name service UP!! " | /bin/mail -s " `date +%m%d%y%H%M` $service_name installed Server: `hostname` $service_name service UP" $dist_list
   else
     echo "`hostname` down $service " > tmp_status_DOWN_`hostname`$service
     sshpass -p 'Nav1Automation2018' scp -o StrictHostKeyChecking=no tmp_status_DOWN_`hostname`$service ansible@10.10.120.199:/tmp
     echo -e "\n server: `hostname` \n $service_name service was DOWN!! " | /bin/mail -s " `date +%m%d%y%H%M` Server: `hostname`  $service_name service DOWN... Please investigate. " $dist_list
  fi
fi

#rm -rf /tmp/tmp_status*
#rm -rf /usr/local/tmp_status*
