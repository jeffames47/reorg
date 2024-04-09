#!/bin/bash
# Last modified: Wed Jan 20 13:37:16 EST 2021

# dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,Benny.Butler@navihealth.com,Chad.Binkley@navihealth.com
export dist_list=jeffrey.ames@wellsky.com
export dist_list=Nima.Sherpa@wellsky.com

ts=`date`
cd /tmp
os1=`uname -r | awk -F\el '{print $2}' | awk -F\. '{print $1}'`
# echo "$ts OS is `uname -a` " > /tmp/filbeat.log
os1=`uname -r`

rpm -qa|grep jdk > /tmp/remove_java_info

cat /tmp/remove_java_info | /bin/mail -s "Server: `hostname` java versions " jeffrey.ames@wellsky.com

rm -f /tmp/remove_java_info

exit
