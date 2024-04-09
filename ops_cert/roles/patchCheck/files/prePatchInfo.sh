#!/bin/bash
#####################################################################################
# This script will get Java and yum info before a patch
# Last modified: prePatchInfo.sh
#####################################################################################

export hst=`hostname`
export working_dir=/tmp/patchCheck
# dist_list=operations@navihealth.com
# dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,Benny.Butler@navihealth.com,Chad.Binkley@navihealth.com
# dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Chad.Binkley@navihealth.com
export dist_list=jeffrey.ames@wellsky.com

### populate file

hostname > $working_dir/$hst.yum_and_java_chk
yum check-update >> $working_dir/$hst.yum_and_java_chk
echo -e "\n Java Version currently is:" >> $working_dir/$hst.yum_and_java_chk
java -version >> $working_dir/$hst.yum_and_java_chk > /dev/null 2>&1
echo -e "\n OS Version currently is:" >> $working_dir/$hst.yum_and_java_chk
cat /etc/redhat-release >> $working_dir/$hst.yum_and_java_chk

mkdir -p /tmp/patchCheck
exit 0
