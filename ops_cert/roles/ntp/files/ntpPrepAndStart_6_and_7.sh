#!/bin/bash
# Last modified: Tue Dec 1 11:57:16 CDT 2020

### global vars

# dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,Benny.Butler@navihealth.com,Chad.Binkley@navihealth.com
# dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Chad.Binkley@navihealth.com
 dist_list=jeffrey.ames@navihealth.com

debug=$1

if [[ $debug = d || $debug = D ]]; then
    echo "At start. Running $0 on `hostname` at `date` "
fi

if [[ $(which ntp | wc -l) -ne 1 ]]
then
   y | yum install ntp
fi

export os1=$(grep -Eo '[0-9]{1,4}' /etc/redhat-release|head -n1)

if [[ $os1 == 7 ]]
then
   systemctl start ntpd
else
   service ntpd start
fi

ntpdate va-dc-01.navihealth.local
/sbin/ntpq -p

exit 0

