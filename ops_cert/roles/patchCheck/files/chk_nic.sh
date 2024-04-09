#!/bin/bash
#############################################a##############################################
# This script will get info before and after a patch and fix TZ
# Last modified: Mon Jul 13 16:23:30 EST 2020
############################################################################################

######## global variables:
export hst=`hostname`
# export dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Chad.Binkley@navihealth.com
# export dist_list=larce@wellsky.com,jeffrey.ames@wellsky.com,luis.arce@wellsky.com,luis.arce@navihealth.com,luis.arce@careport.com
# export dist_list=luis.arce@careporthealth.com,jeffrey.ames@wellsky.com.jeffrey.ames@careporthealth.com
 export dist_list=luis.arce@careporthealth.com

os_level=`uname -r | awk -F\el '{print $2}' | awk -F\. '{print $1}'`

if [[ $(which mailx | wc -l) -ne 1 ]]
  then yum install mailx -y
fi

#nic_chk=$(cat /etc/sysconfig/network-scripts/ifcfg-ens192 | grep 10.10.55.11)

export resolv=0
# echo "resolv1 is $resolv"
#testing resolv=$(cat /etc/resolv.conf | grep safdsdljfks10.10.ff55.)
resolv=$(cat /etc/resolv.conf | grep 10.10.55.11)

# echo "nic_chk1 is  $nic_chk"
# echo "resolv22 is $resolv"

######    if [[ $resolv == 1 ]]
if [[ $resolv == "nameserver 10.10.55.11" ]]
  then
    echo -e "\n For server1: $hst resolv contains the entry $resolv " | /bin/mail -s "For server1: $hst does contains the entry $resolv" $dist_list
#    echo -e "\n For server1: $hst resolv contains the entry $resolv "
# echo "nic_chk3 is  $nic_chk"
  else
# echo "nic_chk3 is  $nic_chk"
    echo -e "\n For server2: $hst resolv does NOT contain the entry $resolv " | /bin/mail -s "For server2: $hst nic does NOT contain the entry $resolv" $dist_list
#    echo -e "\n For server2: $hst resolv does NOT contain the entry $resolv "
fi

exit
