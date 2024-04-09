#!/bin/bash
# Appdynamic agent install
# Last modified: Wed Jan 20 19:53:58 EST 2021

# dist_list=operations@navihealth.com
# dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,Benny.Butler@navihealth.com,Chad.Binkley@navihealth.com
# export dist_list=jeffrey.ames@navihealth.com,BMW.Suwannakat@navihealth.com
export dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com
export dist_list=Jeffrey.ames@navihealth.com

check_n_email() {
service_to_chk=appd
if [[ $os1 == 7 ]]
then
  service_chk=`/etc/init.d/appdynamics-machine-agent status | grep running | wc -l`
  if [[ $service_chk -ge 1 ]]
      then
        # echo " it's running do nothing"
        # echo -e "\n server: `hostname` \n $service_to_chk service WAS started successfully!! "
        echo -e "\n server: `hostname` \n $service_to_chk service WAS started successfully!! " | /bin/mail -s " `date +%m%d%y%H%M` Server: `hostname` $service_to_chk WAS started successfually " $dist_list
      else
        # echo -e "\n server: `hostname` \n $service_to_chk service was NOT started !! "
        echo -e "\n server: `hostname` \n $service_to_chk service was NOT started !! " | /bin/mail -s " `date +%m%d%y%H%M` Server: `hostname` $service_to_chk service WAS NOT started... PLease investigate. " $dist_list
    fi
else
  service_chk=`/etc/init.d/appdynamics-machine-agent status | grep running | wc -l`
  if [[ $service_chk -ge 1 ]]
     then
        # echo -e "\n server: `hostname` \n $service_to_chk service WAS started successfully!! "
        echo -e "\n server: `hostname` \n $service_to_chk service WAS started successfully!! " | /bin/mail -s " `date +%m%d%y%H%M` Server: `hostname` $service_to_chk server WAS started successfually " $dist_list
    else
        # echo -e "\n server: `hostname` \n $service_to_chk service was NOT started !! "
        echo -e "\n server: `hostname` \n $service_to_chk service was NOT started !! " | /bin/mail -s " `date +%m%d%y%H%M` Server: `hostname` $service_to_chk service WAS NOT started... Please investigate. " $dist_list
  fi
fi
}

##################################### main #######################################################

cd /tmp/

echo "`date` installing appd "
echo "`date` installing appd " > appd.log

# Download RPM package and control center config
wget http://172.17.55.103/centos/odd_files_and_scripts/appd/controller-info.xml
#ptt extra not needed wget http://10.10.120.180/centos/odd_files_and_scripts/appd/appdynamics-machine-agent-20.12.0.3016.x86_64.rpm

# Install the RPM Package
# rpm -ivh appdynamics-machine-agent-22.5.0.3361.x86_64.rpm
rpm -ivh 
sleep 3
echo "RPM Package installed"
echo "RPM Package installed" >> appd.log

# Import controller-info.xml file containing the properties for agent-to-controller communication
yes | cp /tmp/controller-info.xml /etc/appdynamics/machine-agent/
sleep 3

# Start the agent
/etc/init.d/appdynamics-machine-agent start
echo "appdynamics-machine-agent starts" >> appd.log

check_n_email

rm -rf appd
#rm -f appd.sh
rm -f appdynamics-machine-agent-20.12.0.3016.x86_64.rpm

exit
