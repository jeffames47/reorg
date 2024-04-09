#!/bin/bash
#############################################a##############################################
# This script will get info before and after a patch and fix TZ
# Last modified: Mon Jul 13 16:23:30 EST 2020
############################################################################################

######## global variables:
export hst=`hostname`
export dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Chad.Binkley@navihealth.com
#  export dist_list=jeffrey.ames@navihealth.com
export temp_dir=/tmp/patchCheck

function usage() {
    echo "------------------------------------------------------------------------------------------------------------------"
    echo ""
    echo "Usage:    $0 b4|after"
    echo ""
    echo "             - for example for before the patch:  sh patching_info.sh B4|before"
    echo "             - for example for after the patch:   sh patching_info.sh AF|after"
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

if [[ ${debug} = d ]]
then
    echo -e "\n Debug mode!  At `date '+%Y-%m-%d %H:%M:%S'` : B4_OR_AFTER is: $B4_OR_AFTER"
    echo -e "\n  os_level is: $os_level "
fi

### populate the small files
hostname > ${temp_dir}/temp_file.$B4_OR_AFTER
rpm -qa >> ${temp_dir}/temp_file.$B4_OR_AFTER
cat /etc/redhat-release >> ${temp_dir}/temp_file.$B4_OR_AFTER
export info_B4=$(cat ${temp_dir}/temp_file.B4 | tail -1)
if [ ${B4_OR_AFTER} == B4 ]; then
    date > ${temp_dir}/tz.B4 ; sleep 1
    export tz_B4=$(cat ${temp_dir}/tz.B4 | awk '{print $5}')
fi

### populate the B4
export tz_B4=$(cat ${temp_dir}/tz.B4 | awk '{print $5}')
cat ${temp_dir}/tz.B4

### populate the AFTER
if [ ${B4_OR_AFTER} == AF ]; then
    date > ${temp_dir}/tz.AF
    export tz_AF=$(cat ${temp_dir}/tz.AF | awk '{print $5}')
    export info_AF=$(cat ${temp_dir}/temp_file.AF | tail -1)
    export patch_info_diff=`diff ${temp_dir}/temp_file.B4 ${temp_dir}/temp_file.AF`
    if [[ ! -z ${patch_info_diff} ]]
    then
        if [[ ${debug} == d ]]
        then
            echo -e "\n OS Before patch: $info_B4 "
            echo -e " OS after patch: $info_AF     ....The patch was.... successful"
        fi
           echo -e "\n Patch for server: $hst \n OS Before patch: $info_B4 \n OS after patch: $info_AF  \n\n Server has been up since `uptime`.  The patch was most likely successful! " | /bin/mail -s " Server: $hst patch was successful " $dist_list
    else
        if [[ ${debug} == d ]]
        then
           echo -e "\n OS Before patch: $info_B4 "
           echo -e " OS after patch: $info_AF     ....The patch was....    NOT SUCCESSFUL"
        fi
           echo -e "\n Patch for server: $hst \n OS Before patch: $info_B4 \n OS after patch: $info_AF  \n\n Before and after files are the same.  The patch was perhaps NOT successful!! " | /bin/mail -s " 'WARNING' Server: $hst The patch was NOT successful " $dist_list
    fi

 ####### timezone change ####

    if [[ ${debug} == d ]]
    then
        echo -e "\n  showing vars in debug mode"
        echo -e "\n tz_B4 $tz_B4"
        echo -e "\n tz_AF $tz_AF"
    fi

    if [[ $tz_B4 == $tz_AF ]]
    then
        sleep 1
        # echo -e " Timezone B4 patch: $tz_B4  \n  timezone  after patch: $tz_AF     ....The timezone is OKAY...   "
    else
      # echo -e " Timezone B4 patch: $tz_B4  \n  timezone  after patch: $tz_AF     ....The timezone is BAD and NOT ok...   "
      echo -e "\n Timezone seemed incorrect for server: $hst after patch \n Time before patch: $tz_B4  ....TZ after patch: $tz_AF !!! \n The script is correcting this now, but please verify time zone against /tmp/temp_file.B4 " | /bin/mail -s " 'WARNING' Server: $hst The time zone seemed invalid after patch!  Please double check it. " $dist_list
      if [[ $os_level == 7 ]]
      then
          rm -f /etc/localtime
          ln -s /usr/share/zoneinfo/$tz_B4 /etc/localtime
          timedatectl set-timezone $tz_B4
      else
          rm -f /etc/localtime       # removed the original symlink
          ln -s /usr/share/zoneinfo/$tz_B4 /etc/localtime    # create the new symlink and make it the new localtime
      fi
    fi
fi

    if [[ ${debug} == d ]]
    then
          echo "je suis fini...  centos: $os_level  date: `date` "
    fi

exit 0
