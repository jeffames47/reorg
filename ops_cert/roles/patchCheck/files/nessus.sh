#!/bin/bash
# Last modified: Thu Jan 21 13:37:16 EST 2021

# dist_list=operations@navihealth.com
# dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,Benny.Butler@navihealth.com,Chad.Binkley@navihealth.com
# dist_list=jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,bruce.jackson@navihealth.com
  export dist_list=jeffrey.ames@wellsky.com
  export dist_list=nima.sherpa@careporthealth.com

check_n_email() {
service_to_chk=nessus
service_name=nessus
if [[ $os1 == 7 ]]
then
  service_chk=`systemctl status $service_to_chk | grep running | wc -l`
  if [[ $service_chk -eq 1 ]]
      then
        # echo " it's running do nothing"
        echo -e "\n server: `hostname` \n $service_name service WAS started successfully!! " | /bin/mail -s " `date +%m%d%y%H%M` installed Server: `hostname` $service_name service started successfully " $dist_list
      else
        echo -e "\n server: `hostname` \n $service_name service was NOT started !! " | /bin/mail -s " `date +%m%d%y%H%M` Server: `hostname` $service_name service WAS NOT started... Please investigate. " $dist_list
    fi
else
  service_chk=`service $service_to_chk status | grep running | wc -l`
  if [[ $service_chk -eq 1 ]]
     then
        echo -e "\n server: `hostname` \n $service_name service WAS started successfully!! " | /bin/mail -s " `date +%m%d%y%H%M` installed Server: `hostname` $service_name service WAS started successfully " $dist_list
    else
        echo -e "\n server: `hostname` \n $service_name service was NOT started !! " | /bin/mail -s " `date +%m%d%y%H%M` Server: `hostname`  $service_name service WAS NOT started... Please investigate. " $dist_list
  fi
fi
}


############### main ######################

ts=`date`
cd /tmp
export os1=$(grep -Eo '[0-9]{1,4}' /etc/redhat-release|head -n1)

if [[ $(which mailx | wc -l) -ne 1 ]]
  then yum install mailx -y
else
  sleep 1
fi

if [[ $os1 == 7 ]]
then
#  yum update ca-certificates-2021.2.50-72.el7_9.noarch -y
  rpm -ihv NessusAgent-10.1.3-es7.x86_64.rpm
  cd /tmp ; rpm -ihv NessusAgent-10.1.3-es7.x86_64.rpm
else
  cd /tmp ; rpm -ihv Nessus-8.15.8-es6.x86_64.rpm
fi

curl -H 'X-Key: 18187a2362968d8e18a288eb4c23703d8fb71d5b00b08b0db1f0adca27b653d1' 'https://cloud.tenable.com/install/agent?groups=CTP' | bash
/opt/nessus_agent/sbin/nessuscli agent link --key=18187a2362968d8e18a288eb4c23703d8fb71d5b00b08b0db1f0adca27b653d1 --cloud --groups=CTP

if [[ $os1 == 7 ]]
then
   systemctl start NessusAgent
   /bin/systemctl start nessusagent.service
else
   service NessusAgent start
   service nessusagent.service start
fi

check_n_email

exit
