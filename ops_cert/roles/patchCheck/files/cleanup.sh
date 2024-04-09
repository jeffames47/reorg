#!/bin/bash
#############################################a#######################################################
# This script will get info b4 and after a patch and check the OS to see if it changed
# Last modified: Fri  Apr 03 12:02:17 EST 2020
#####################################################################################################

######## global variables:

export hst=`hostname`
# dist_list=operations@navihealth.com
# dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,Benny.Butler@navihealth.com,Chad.Binkley@navihealth.com
# dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Chad.Binkley@navihealth.com
export dist_list=jeffrey.ames@navihealth.com

function usage() {
    echo "------------------------------------------------------------------------------------------------------------------"
    echo ""
    echo "Usage:    $0 b4|after"
    echo "             - for example for before the patch:  sh patching_info.sh b4"
    echo "             - for example for after the patch:  sh patching_info.sh after"
    echo ""
    echo "------------------------------------------------------------------------------------------------------------------"
    exit
}

############################ main #################################

B4_OR_AFTER=$1
debug=$2

if [[ -z ${B4_OR_AFTER} ]]
    then
        usage
fi

### get input no matter what is entered and convert it to B4 or AF
if [ ${B4_OR_AFTER} == B ] || [ ${B4_OR_AFTER} == b ] || [ ${B4_OR_AFTER} == b4 ] || [ ${B4_OR_AFTER} == B4 ]; then
    export Before_or_after_switch=before
    export B4_OR_AFTER=B4
elif [ ${B4_OR_AFTER} == A ] || [ ${B4_OR_AFTER} == a ] || [ ${B4_OR_AFTER} == AF ] || [ ${B4_OR_AFTER} == af ]; then
    export Before_or_after_switch=after
    export B4_OR_AFTER=AF
elif [ ${B4_OR_AFTER} == BEFORE ] || [ ${B4_OR_AFTER} == before ]; then
    export Before_or_after_switch=before
    export B4_OR_AFTER=before
elif [ ${B4_OR_AFTER} == AFTER ] || [ ${B4_OR_AFTER} == after ]; then
    export Before_or_after_switch=after
    export B4_OR_AFTER=after
else
    echo "Before_or_after_switch $B4_OR_AFTER_SW IS INVALID!"
    usage
fi

if [[ ${debug} = d ]]
then
    echo -e "\n Debug mode!  At `date '+%Y-%m-%d %H:%M:%S'` : B4_OR_AFTER is: $B4_OR_AFTER"
fi

### populate small file
hostname > /tmp/temp_file.$B4_OR_AFTER
rpm -qa >> /tmp/temp_file_ALL_PS.$B4_OR_AFTER
cat /etc/redhat-release >> /tmp/temp_file.$B4_OR_AFTER
export info_B4=$(cat /tmp/temp_file.B4 | grep CentOS | awk '{print $4}')

### populate larger file
#hostname > /tmp/temp_file_ALL_PS.$B4_OR_AFTER
#uname -a >> /tmp/temp_file_ALL_PS.$B4_OR_AFTER
#echo -e "\n Current running processies: " >> /tmp/temp_file_ALL_PS.$B4_OR_AFTER
#ps -ef >> /tmp/temp_file_ALL_PS.$B4_OR_AFTER
#echo -e "\n top cpu: \n  " >> /tmp/temp_file_ALL_PS.$B4_OR_AFTER
#ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -10 >> /tmp/temp_file_ALL_PS.$B4_OR_AFTER
#rpm -qa >> /tmp/temp_file_ALL_PS.$B4_OR_AFTER
#cat /etc/redhat-release >> /tmp/temp_file_ALL_PS.$B4_OR_AFTER

### do diff or B4 and AF ( before and after ) files if running after patch
if [ ${B4_OR_AFTER} == AF ]; then
    export info_AF=$(cat /tmp/temp_file.AF | grep CentOS | awk '{print $4}')
    export patch_info_diff=`diff /tmp/temp_file.B4 /tmp/temp_file.AF`
    if [[ ! -z ${patch_info_diff} ]]
    then
        sleep 1
        if [[ ${debug} == d ]]
        then
            echo -e "\n OS Before patch: $info_B4 "
            echo -e " OS after patch: $info_AF     ....The patch was.... successful"
            # run the xls reformat and update script if the patch was successful
            sh reformat_csv.sh d` 
        fi
           sleep 1
           # run the xls reformat and update script if the patch was successful
           sh reformat_csv.sh d`
            #echo -e "\n Patch for server: $hst \n OS Before patch: $info_B4 \n OS after patch: $info_AF  \n\n The patch was successful!! " | /bin/mail -s " 'WARNING' `date +%m%d%y%H%M` Server: $hst The patch was successful " $dist_list
    else
        if [[ ${debug} == d ]]
        then
           echo -e "\n OS Before patch: $info_B4 "
           echo -e " OS after patch: $info_AF     ....The patch was....    NOT SUCCESSFUL"
        fi
           echo -e "\n Patch for server: $hst \n OS Before patch: $info_B4 \n OS after patch: $info_AF  \n\n The patch was NOT successful!! " | /bin/mail -s " 'WARNING' `date +%m%d%y%H%M` Server: $hst The patch was NOT successful " $dist_list
    fi
fi

exit 0


