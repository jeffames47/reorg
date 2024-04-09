#!/bin/bash
#############################################a##############################################
# This script will get info before and after a patch and fix TZ
# Last modified: Mon Jul 13 16:23:30 EST 2020
############################################################################################

######## global variables:
export hst=`hostname`
# export dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Chad.Binkley@navihealth.com
export dist_list=jeffrey.ames@navihealth.com,larce@navihealth.com
export dist_list=jeffrey.ames@navihealth.com

export temp_dir=/tmp

B4_OR_AFTER=AF

debug=$1
os_level=`uname -r | awk -F\el '{print $2}' | awk -F\. '{print $1}'`

if [[ $(which mailx | wc -l) -ne 1 ]]
  then yum install mailx -y
fi

if [[ ${debug} = d ]]
then
    echo -e "\n Debug mode!  At `date '+%Y-%m-%d %H:%M:%S'` : B4_OR_AFTER is: $B4_OR_AFTER"
    echo -e "\n  os_level is: $os_level "
fi

### populate the small files
# rpm -qa >> ${temp_dir}/temp_file.$B4_OR_AFTER
cat /etc/redhat-release >> ${temp_dir}/temp_file.$B4_OR_AFTER
info_AF=$(cat ${temp_dir}/temp_file.AF | tail -1)

# send email with info

echo -e "\n For server: $hst \n \n  OS after patch: $info_AF \n space info: \n `df -h /boot`   \n\n Server has been up since `uptime`.  " | /bin/mail -s "Server: $hst OS after patch: $info_AF " $dist_list

exit 0
