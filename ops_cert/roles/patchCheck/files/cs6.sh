#!/bin/bash
# Last modified: Thu Jan 21 13:37:16 EST 2021

# dist_list=operations@navihealth.com
# dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,Benny.Butler@navihealth.com,Chad.Binkley@navihealth.com
# dist_list=jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,bruce.jackson@navihealth.com
  export dist_list=jeffrey.ames@wellsky.com

check_n_email() {
service_to_chk=falcon-sensor
service_name=falcon-sensor
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

yum update ca-certificates-2021.2.50-72.el7_9.noarch -y

if [[ $os1 == 7 ]]
then
  rpm -ihv falcon-sensor-6.46.0-14306.el7.x86_64.rpm
else
  rpm -ihv falcon-sensor-6.50.0-14712.el6.x86_64.rpm
  ###########rpm -ihv xagt-32.30.12-1.el6.x86_64.rpm | tee -a /tmp/f.log
  sleep 1
fi

/opt/CrowdStrike/falconctl -s --cid=D6887CAD408C480081695F1D9ED93B82-CB

if [[ $os1 == 7 ]]
then
   service falcon-sensor start
   systemctl start falcon-sensor
else
   service falcon-sensor start
   systemctl start falcon-sensor
fi

check_n_email

#rm -f /tmp/cs.sh
#rm -f /tmp/xagt-32.30.12-1.el6.x86_64.rpm

#exit
