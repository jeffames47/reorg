#!/bin/bash
#This script is used for deploying Splunk UF's to CTP's machines in BOS.
# Last modified: Mon Mar 13 11:43:34 EST 2023

export service=splunk
export dist_list=jeffrey.ames@wellsky.com

######## Submodules

##############################################################
# This function will check a service and run it if it is down
##############################################################
check_service_and_run_if_down() {

# if cat /etc/passwd | grep splunk ; then echo "splunk exist"; else useradd -g root -d /opt/splunk splunk; fi

service_chk_wc=`ps -ef | grep $service |  egrep -v grep | wc -l`
hst=`hostname`
if [[ $service_chk_wc == 0 ]]
  then
    sh -c "false; exit 0" ; echo $?
    echo -e "\n Service $service is down." | /bin/mail -s " 'WARNING' `date +"%m-%d-%y"` Server: $hst Service $service is down. " $dist_list
  else
    sh -c "false" ; echo $?
    echo -e "\n Service $service is UP !!!  " | /bin/mail -s " 'YES' `date +"%m-%d-%y"` Server: $hst Service $service is UP !!! " $dist_list
fi
}

####################################### main ####################################################

  export h=`hostname`

  /opt/splunkforwarder/bin/splunk stop

  rm -f /opt/splunkforwarder/etc/system/local/deploymentclient.conf
  rm -f /opt/splunkforwarder/etc/system/local/outputs.conf

  touch /opt/splunkforwarder/etc/system/local/deploymentclient.conf
  touch /opt/splunkforwarder/etc/system/local/outputs.conf
  echo "[deployment-client]" >> /opt/splunkforwarder/etc/system/local/deploymentclient.conf
  echo "clientName = "$h >> /opt/splunkforwarder/etc/system/local/deploymentclient.conf
  echo ""
  echo "[target-broker:deploymentServer]" >> /opt/splunkforwarder/etc/system/local/deploymentclient.conf
  echo "targetUri = 172.20.100.201:8089" >> /opt/splunkforwarder/etc/system/local/deploymentclient.conf
  ########echo "targetUri = 172.18.100.217:8089" >> /opt/splunkforwarder/etc/system/local/deploymentclient.conf
  echo "[tcpout:CTP_HF]" >> /opt/splunkforwarder/etc/system/local/outputs.conf
  echo "server = 172.20.100.202:9997" >> /opt/splunkforwarder/etc/system/local/outputs.conf
  #######echo "server = 172.18.100.218:9997" >> /opt/splunkforwarder/etc/system/local/outputs.conf

  /opt/splunkforwarder/bin/splunk start

exit
