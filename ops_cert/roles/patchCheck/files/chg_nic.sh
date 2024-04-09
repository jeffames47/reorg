#!/bin/bash
#############################################a##############################################
# This script will get info before and after a patch and fix TZ
# Last modified: Mon Jul 13 16:23:30 EST 2020
############################################################################################

######## global variables:
export hst=`hostname`
# export dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Chad.Binkley@navihealth.com
export dist_list=jeffrey.ames@navihealth.com,larce@navihealth.com
export dist_list=jeffrey.ames@navihealth.com
export dist_list=luis.arce.ames@navihealth.com,luis.arce.ames@wellsky.com,luis.arce.ames@carepoint.com

export temp_dir=/tmp

B4_OR_AFTER=AF

debug=$1
os_level=`uname -r | awk -F\el '{print $2}' | awk -F\. '{print $1}'`
nic_level=`uname -r | awk -F\el '{print $2}' | awk -F\. '{print $1}'`

if [[ $(which mailx | wc -l) -ne 1 ]]
  then yum install mailx -y
fi


    pid_count=$(ps -ef | egrep $service | egrep -v grep | wc -l)
    pid=$(ps -ef | egrep $service | awk '{print $2}')
    service_chk_centos6_wc=`ps -ef | grep $service | grep -v grep | wc -l`
    service_chk_wc=`systemctl status $service | grep active | grep running | wc -l`

nic_chk=$(cat /etc/sysconfig/network-scripts/ifcfg-ens192 | grep 10.10.55.11)




  if [[ $service_chk_wc == 1 ]]
    then
      sh -c "false; exit 0" ; echo $?
    else
      sh -c "false" ; echo $?
  fi


exit


# rpm -qa >> ${temp_dir}/temp_file.$B4_OR_AFTER
cat /etc/redhat-release >> ${temp_dir}/temp_file.$B4_OR_AFTER
info_AF=$(cat ${temp_dir}/temp_file.AF | tail -1)

# send email with info

echo -e "\n For server: $hst \n \n  OS after patch: $info_AF \n space info: \n `df -h /boot`   \n\n Server has been up since `uptime`.  " | /bin/mail -s "Server: $hst OS after patch: $info_AF " $dist_list

exit 0
