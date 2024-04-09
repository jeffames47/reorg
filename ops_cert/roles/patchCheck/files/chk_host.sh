
#!/bin/bash
#############################################a##############################################
# This script will get info before and after a patch and fix TZ
# Last modified: Mon Jul 13 16:23:30 EST 2020
############################################################################################

######## global variables:
export hst=`hostname`
#export dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Chad.Binkley@navihealth.com
export dist_list=jeffrey.ames@navihealth.com
export hst=`hostname`

function usage() {
    echo "------------------------------------------------------------------------------------------------------------------"
    echo ""
    echo "Usage:    $0 <1,2,3,etc>"
    echo ""
    echo "             - for example for hostnames ending in 1 enter 1:  sh hostchk.sh 1"
    echo ""
    echo "------------------------------------------------------------------------------------------------------------------"
    exit
}

############################ main #################################


debug=$2
os_level=`uname -r | awk -F\el '{print $2}' | awk -F\. '{print $1}'`

#if [[ -z ${B4_OR_AFTER} ]]
#    then
#        usage
#fi

host_shortname=`uname -n | cut -d"." -f1`
echo " host_shortname= $host_shortname"

host_num=`echo $host_shortname | grep -Eo '[0-9]+$' `
echo " host_num= $host_num"

if [[ $host_num == 01 ]]
then
  echo $host_num
fi

