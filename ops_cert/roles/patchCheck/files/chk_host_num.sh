#!/bin/bash
#############################################a##############################################
# This script will: exit is host number matches 
# Last modified: Mon Jul 19 13:32:57 EST 2021
############################################################################################

######## global variables:
export hst=`hostname`
#export dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Chad.Binkley@navihealth.com
export dist_list=jeffrey.ames@navihealth.com

hst=`hostname`
hst_input=$1
debug=$2
os_level=`uname -r | awk -F\el '{print $2}' | awk -F\. '{print $1}'`

host_shortname=`uname -n | cut -d"." -f1`
echo " host_shortname= $host_shortname"

host_num=`echo $host_shortname | grep -Eo '[0-9]+$' `
echo " host_num= $host_num"


if [[ $host_num == $hst_input ]];
#if [[ $host_num == 01 ]];
then
    echo "hosts match...  host_num $host_num  hst_input $hst_input"
  else
    echo "hosts DO NOT match!  host_num $host_num  hst_input $hst_input"
    exit 
fi

