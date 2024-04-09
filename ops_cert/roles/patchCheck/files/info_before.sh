#!/bin/bash
#############################################a##############################################
# This script will get info before and after a patch and it will also CHECK and fix timezone issues
# Last modified:  Wed Jan 12 11:56:56 CST 2022
############################################################################################

# global variables:
export hst=`hostname`
export temp_dir=/tmp/patchCheck
#  dist_list=jeffrey.ames@navihealth.com,Chad.Binkley@navihealth.com,Bruce.Jackson@navihealth.com
dist_list=jeffrey.ames@careporthealth.com
dist_list_with_benny=jeffrey.ames@careporthealth.com

# functions:
function usage() {
    echo "------------------------------------------------------------------------------------------------------------------"
    echo ""
    echo "Usage:    $0 b4|after"
    echo ""
    echo "             - for example for before the patch:  sh patchCheck.sh B4|before"
    echo "             - for example for after the patch:   sh patchCheck.sh AF|after"
    echo ""
    echo "------------------------------------------------------------------------------------------------------------------"
    exit
}


############################ main #################################

B4_OR_AFTER=$1
debug=$2
os_level=`uname -r | awk -F\el '{print $2}' | awk -F\. '{print $1}'`

if [[ -z ${B4_OR_AFTER} ]]
    then
        usage
fi

if [[ ${debug} = d ]]
then
    echo -e "\n Debug mode!  At `date '+%Y-%m-%d %H:%M:%S'` : B4_OR_AFTER is: $B4_OR_AFTER"
    echo -e "\n  os_level is: $os_level "
    echo -e   "\n binfo_B4= $binfo_B4"
fi


### get input no matter what is entered and convert it to: B4 or AF
if [ ${B4_OR_AFTER} == B ] || [ ${B4_OR_AFTER} == b ] || [ ${B4_OR_AFTER} == b4 ] || [ ${B4_OR_AFTER} == B4 ]; then
    export Before_or_after_switch=before
    export B4_OR_AFTER=B4
elif [ ${B4_OR_AFTER} == A ] || [ ${B4_OR_AFTER} == a ] || [ ${B4_OR_AFTER} == AF ] || [ ${B4_OR_AFTER} == af ]; then
    export Before_or_after_switch=after
    export B4_OR_AFTER=AF
elif [ ${B4_OR_AFTER} == BEFORE ] || [ ${B4_OR_AFTER} == before ]; then
    export Before_or_after_switch=before
    export B4_OR_AFTER=B4
elif [ ${B4_OR_AFTER} == AFTER ] || [ ${B4_OR_AFTER} == after ]; then
    export Before_or_after_switch=after
    export B4_OR_AFTER=AF
else
    echo "Before_or_after_switch $B4_OR_AFTER_SW IS INVALID!"
    usage
fi

binfo_B4=`cat /etc/redhat-release ; uname -r`

### populate the small files
hostname > ${temp_dir}/temp_file.$B4_OR_AFTER
uname -r >> ${temp_dir}/temp_file.$B4_OR_AFTER
echo -ne '\n' | update-alternatives --config java | grep java >> ${temp_dir}/temp_file.$B4_OR_AFTER
#?  cat /etc/redhat-release >> ${temp_dir}/temp_file.$B4_OR_AFTER
export info_B4=$(cat ${temp_dir}/temp_file.B4 | tail -1)
if [ ${B4_OR_AFTER} == B4 ]; then
    date > ${temp_dir}/tz.B4 ; sleep 1
    export tz_B4=$(cat ${temp_dir}/tz.B4 | awk '{print $5}')
fi

exit 

### populate the B4
export tz_B4=$(cat ${temp_dir}/tz.B4 | awk '{print $5}')
cat ${temp_dir}/tz.B4

