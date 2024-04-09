#!/bin/bash
# Last modified: Wed Jan 14 13:37:16 EST 2021

# dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,Benny.Butler@navihealth.com,Chad.Binkley@navihealth.com
export dist_list=jeffrey.ames@navihealth.com

ts=`date`
cd /tmp

export os1=$(grep -Eo '[0-9]{1,4}' /etc/redhat-release|head -n1)
if [[ $os1 == 7 ]]
then
  systemctl stop dcservice
  echo "done" >> /tmp/ME.log
else
  service dcservice stop
fi

rm -f /tmp/UEMS*
rm -f /tmp/*ME.sh
rm -f /tmp/yum_save_tx.*

exit
