#!/bin/bash
# Appd upgrade
# Last modified: Fri Jun 24 14:17:07 EST 2022 - fix rpm 
dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Chad.Binkley@navihealth.com
dist_list_with_benny=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Chad.Binkley@navihealth.com,Benny.Butler@navihealth.com
export dist_list=jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,Benny.Butler@navihealth.com
export dist_list=jeffrey.ames@navihealth.com

###########################  Functions: 

check_if_ok_n_email() {
service_to_chk=appd
### service_chk=`service_chk_wc=`ps -ef | grep -i appd | grep -i Dlog4j | wc -l`
service_chk=`/etc/init.d/appdynamics-machine-agent status | grep running | wc -l`
appd_version=`rpm -qa appdynamics-machine-agent`
echo "appd_version= $appd_version"

  if [[ $service_chk -ge 1 ]]
      then
        # echo " it's running do nothing"
        echo -e "\n server: `hostname` \n $service_to_chk service WAS updated and started successfully!!  \n version is   $appd_version " | /bin/mail -s " `date +%m%d%y%H%M` Server: `hostname` $service_to_chk WAS restarted with version $appd_version " $dist_list
      else
        # echo -e "\n server: `hostname` \n $service_to_chk service was NOT started !! "
        echo -e "\n server: `hostname` \n $service_to_chk service was NOT started !! \n version is   $appd_version " | /bin/mail -s " `date +%m%d%y%H%M` Server: `hostname` $service_to_chk service WAS NOT started... Please investigate. " $dist_list
    fi
}


##################################### main #######################################################

cd /tmp/

echo "`date` upgrading appd "
echo "`date` upgrading appd " > appd_upgrade.log

#Makes a copy of current controller file
yes | cp /etc/appdynamics/machine-agent/controller-info.xml /etc/appdynamics/machine-agent/controller-info.xml.bk
yes | cp /opt/appdynamics/machine-agent/conf/controller-info.xml /opt/appdynamics/machine-agent/conf/controller-info.xml.bk
yes | cp /etc/init.d/appdynamics-machine-agent /etc/init.d/appdynamics-machine-agent.bk
sleep 1

# Uninstall old package version
rpm -e appdynamics-machine-agent-22.4.0.3344.x86_64.rpm
#rpm -e appdynamics-machine-agent-21.12.1.3206.x86_64.rpm
#rpm -e appdynamics-machine-agent-20.12.0.3016.x86_64.rpm

# Install the RPM Package
rpm -Uvh appdynamics-machine-agent-22.5.0.3361.x86_64.rpm
sleep 1

appd_version=`rpm -qa appdynamics-machine-agent`
sleep 1

# debug stuff...   
# echo "RPM Package Upgraded"
# echo "RPM Package Upgraded" >> appd_upgrade.log

# Import controller-info.xml file containing the properties for agent-to-controller communication
yes | cp /tmp/controller-info.xml /etc/appdynamics/machine-agent/
yes | cp /etc/init.d/appdynamics-machine-agent.bk /etc/init.d/appdynamics-machine-agent
yes | cp /etc/appdynamics/machine-agent/controller-info.xml.bk /etc/appdynamics/machine-agent/controller-info.xml
yes | cp /opt/appdynamics/machine-agent/conf/controller-info.xml.bk /opt/appdynamics/machine-agent/conf/controller-info.xml

# re-Start the agent
/etc/init.d/appdynamics-machine-agent restart
# echo "appdynamics-machine-agent restarted" >> appd_upgrade.log

check_if_ok_n_email

rm -f /tmp/appd_upgrade*
rm -f /tmp/appdynamics-machine-agent-*.rpm

exit
