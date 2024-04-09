#!/bin/bash
####################################################################
# This script will check to see if a service is down and restart it
# This requires input variable with the service name
# Last modified:  Tue Jun 8 15:32:24 EDT 2021  - Jeff Ames
# usage : sh service_chk_and_restart.sh <services> d=optional debug

######## global variables:a

export up_down_bit=0
dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com
dist_list=jeffrey.ames@naviHealth.com

######## Submodules:

##############################################################
# This function will check a service and run it if it is down
##############################################################
check_service_and_run_if_down() {
    pid_count=$(ps -ef | egrep $service | egrep -v grep | wc -l)
    pid=$(ps -ef | egrep $service | awk '{print $2}')
    service_chk_centos6_wc=`ps -ef | grep $service | grep -v grep | wc -l`
    service_chk_wc=`systemctl status $service | grep active | grep running | wc -l`
    if [[ ${DEBUG} = d ]]
    then
        echo  -e  "\n In check_service_and_run_if_down   debug mode.....   service_chk_wc is: $service_chk_wc $service is: $service pid is: $pid"
    fi

if [[ ${DEBUG} = d ]]
then
    echo  -e  "\n In check_service_and_run_if_down service_chk_wc is $service_chk_wc   service is $service"
    echo  -e  "\n In check_service_and_run_if_down service_chk_wc is $service_chk_wc   service is $service"
fi

  if [[ $service_chk_wc == 1 ]]
    then
      sh -c "false; exit 0" ; echo $?
    else
      sh -c "false" ; echo $?
  fi
}

############################ main #################################

service=$1
DEBUG=$2

check_service_and_run_if_down

exit 4
