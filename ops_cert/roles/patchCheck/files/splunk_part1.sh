#!/bin/bash
#This script is used for deploying Splunk UF's to CTP's machines in BOS.

########  dist_list=jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,bruce.jackson@navihealth.com
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

wget -O /tmp/splunkforwarder-9.0.1-82c987350fde-Linux-x86_64.tgz "https://download.splunk.com/products/universalforwarder/releases/9.0.1/linux/splunkforwarder-9.0.1-82c987350fde-Linux-x86_64.tgz" --no-check-certificate
sleep 10

#md5check=$(md5sum /tmp/splunkforwarder-9.0.1-82c987350fde-Linux-x86_64.tgz)
h=`hostname`

#if [[ "${md5check}" == "47a69f1ae8543130c99af49f95f73c21  /tmp/splunkforwarder-9.0.1-82c987350fde-Linux-x86_64.tgz" ]];
#then
  tar xzf /tmp/splunkforwarder-9.0.1-82c987350fde-Linux-x86_64.tgz -C /opt
  chown -R tomcat:tomcat /opt/splunkforwarder
  chmod -R 777 /opt/splunkforwarder
  # rm -rf /opt/splunkforwarder/ftr
  /opt/splunkforwarder/bin/splunk start --accept-license --no-prompt
  /opt/splunkforwarder/bin/splunk stop
  touch /opt/splunkforwarder/etc/system/local/deploymentclient.conf
  touch /opt/splunkforwarder/etc/system/local/outputs.conf
  echo "[deployment-client]" >> /opt/splunkforwarder/etc/system/local/deploymentclient.conf
  echo "clientName = "$h >> /opt/splunkforwarder/etc/system/local/deploymentclient.conf
  echo ""
  echo "[target-broker:deploymentServer]" >> /opt/splunkforwarder/etc/system/local/deploymentclient.conf
  echo "targetUri = 172.20.100.201:8089" >> /opt/splunkforwarder/etc/system/local/deploymentclient.conf
  echo "[tcpout:CTP_HF]" >> /opt/splunkforwarder/etc/system/local/outputs.conf
  echo "server = 172.20.100.202:9997" >> /opt/splunkforwarder/etc/system/local/outputs.conf
#  /opt/splunkforwarder/bin/splunk enable boot-start --answer-yes --no-prompt -user tomcat

 
  chmod -R 777 /opt/splunk

 
  #     /opt/splunkforwarder/bin/splunk start --answer-yes --no-prompt --accept-license --accept-terms-and-conditions
  # /opt/splunkforwarder/bin/splunk enable boot-start
 # /opt/splunkforwarder/bin/splunk start 
  
#else
#  echo "Checksum did not match"
#fi

#check_service_and_run_if_down

#exit
