#!/bin/bash
#############################################a##############################################
# This script will RUN CimTrak Agent
# Last modified: 9/29
############################################################################################

######## global variables:
export hst=`hostname`
export dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Chad.Binkley@navihealth.com
export dist_list=jeffrey.ames@navihealth.com
export temp_dir=/tmp/patchCheck

############################ main #################################

debug=$1
os_level=`uname -r | awk -F\el '{print $2}' | awk -F\. '{print $1}'`

cd /tmp/LINUX
#scp -r 10.10.120.200:/tmp/LINUX/* .
hst=`hostname`
# rsync -rap -apvrc /tmp/LINUX/ mavsg-twradm-04:/tmp
cd /tmp/LINUX
# chmod 777 ctagent_e_setup_linux_x64_04002000_17139_20200728.run

sleep 1
yes | ./ctagent_e_setup_linux_x64_04002000_17139_20200728.run --unattendedmodeui minimal --prefix /opt/Cimcor/CimTrak --agentname `hostname` --repository PRBNAWFIM01.navihealth.local --port 3749 --user cimtrak_installer --password '!nstall2020'

#if (( $? != 0 ))
#then
#    echo -e "\n CimTrak Agent NOT successful for server: $hst \n  " | /bin/mail -s " Server: $hst CimTrak Agent install was NOT successful " $dist_list
#else
#    Cim_pid=`ps -ef | grep Cim | grep opt | awk '{print $2}'`
#    echo -e "\n CimTrak Agent successful for server: $hst \n The Cimtrak PID is: $Cim_pid  " | /bin/mail -s " Server: $hst CimTrak Agent install was successful " $dist_list
#fi
sleep 1

rm -f yum_save_tx.*

exit 0

