#!/bin/bash
# Last modified: 7/13

# dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,Benny.Butler@navihealth.com,Chad.Binkley@navihealth.com
export dist_list=jeffrey.ames@navihealth.com

ts=`date`
cd /tmp

export os1=$(grep -Eo '[0-9]{1,4}' /etc/redhat-release|head -n1)
if [[ $os1 == 7 ]]
then
  systemctl stop xagt
else
  service xagt stop
fi


exit
