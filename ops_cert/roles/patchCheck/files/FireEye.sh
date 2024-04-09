#!/bin/bash
# Last modified: Thu Jan 21 13:37:16 EST 2021

# dist_list=operations@navihealth.com
# dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,Benny.Butler@navihealth.com,Chad.Binkley@navihealth.com
# dist_list=jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,bruce.jackson@navihealth.com
  export dist_list=jeffrey.ames@navihealth.com

check_n_email() {
service_to_chk=xagt
service_name=FireEye

if [[ $os1 == 7 ]]
then
  service_chk=`systemctl status $service_to_chk | grep running | wc -l`
  if [[ $service_chk -eq 1 ]]
      then
        # echo " it's running do nothing"
        echo -e "\n server: `hostname` \n $service_name service WAS started successfully!! " | /bin/mail -s " `date +%m%d%y%H%M` Fireeye installed Server: `hostname` $service_name service started successfully " $dist_list
      else
        echo -e "\n server: `hostname` \n $service_name service was NOT started !! " | /bin/mail -s " `date +%m%d%y%H%M` Server: `hostname` $service_name service WAS NOT started... Please investigate. " $dist_list
    fi
else
  service_chk=`service $service_to_chk status | grep running | wc -l`
  if [[ $service_chk -eq 1 ]]
     then
        echo -e "\n server: `hostname` \n $service_name service WAS started successfully!! " | /bin/mail -s " `date +%m%d%y%H%M` Fireeye installed Server: `hostname` $service_name service WAS started successfully " $dist_list
    else
        echo -e "\n server: `hostname` \n $service_name service was NOT started !! " | /bin/mail -s " `date +%m%d%y%H%M` Server: `hostname`  $service_name service WAS NOT started... Please investigate. " $dist_list
  fi
fi
}


############### main ######################

ts=`date`
cd /tmp
export os1=$(grep -Eo '[0-9]{1,4}' /etc/redhat-release|head -n1)

echo "$ts Expanding agent .tgz " > /tmp/FireEye.log
echo "$ts tar zxvf IMAGE_HX_AGENT_LINUX_32.30.12.tgz " > /tmp/FireEye.log
tar zxvf IMAGE_HX_AGENT_LINUX_32.30.12.tgz | tee -a /tmp/FireEye.log
sleep 2
echo "$ts installing rpm " >> /tmp/FireEye.log
if [[ $os1 == 7 ]]
then
  echo "$ts rpm -ihv xagt-32.30.12-1.el7.x86_64.rpm  " >> /tmp/FireEye.log
  rpm -ihv xagt-32.30.12-1.el7.x86_64.rpm | tee -a /tmp/FireEye.log
  sleep 2
else
  echo "$ts rpm -ihv xagt-32.30.12-1.el6.x86_64.rpm  " >> /tmp/FireEye.log
  rpm -ihv xagt-32.30.12-1.el6.x86_64.rpm | tee -a /tmp/FireEye.log
  sleep 2
fi
echo "$ts running agent " >> /tmp/FireEye.log
echo "$ts /opt/fireeye/bin/xagt -i agent_config.json " >> /tmp/FireEye.log
/opt/fireeye/bin/xagt -i agent_config.json | tee -a /tmp/FireEye.log
sleep 2
echo "$ts starting service " >> /tmp/FireEye.log
echo "$ts systemctl start xagt.service " >> /tmp/FireEye.log

if [[ $os1 == 7 ]]
then
  systemctl start xagt.service | tee -a /tmp/FireEye.log
  echo "done" >> /tmp/FireEye.log
else
  service xagt start | tee -a /tmp/FireEye.log
  echo "done" >> /tmp/FireEye.log
fi

echo "$ts OS is `uname -a` " >> /tmp/FireEye.log
echo "$ts Wrapping up Install, Attempting Email & Cleanup" >> /tmp/FireEye.log
echo "$ts OS is `uname -a` " >> /tmp/FireEye.log
check_n_email

rm -f /tmp/IMAGE_HX_AGENT_LINUX_32.30.12.tgz
rm -f /tmp/agent_config.json
rm -f /tmp/xagt-32.30.*.rpm
rm -f /tmp/FireEye.*

#exit
