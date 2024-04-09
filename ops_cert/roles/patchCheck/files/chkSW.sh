#!/bin/bash
# Last modified: Wed Jan 20 13:37:16 EST 2021

# dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,Benny.Butler@navihealth.com,Chad.Binkley@navihealth.com
export dist_list=jeffrey.ames@wellsky.com
export dist_list=Nima.Sherpa@wellsky.com

ts=`date`
cd /tmp
os1=`uname -r`

service=swiagent
service2=SolarWinds
DEBUG=$3

export swpid=$(ps -ef | egrep $service | grep -v grep| awk '{print $2}')
export swpid2=$(ps -ef | egrep $service2 | grep -v grep| awk '{print $2}')

echo " swpid $swpid"
echo " swpid2 $swpid2"

#yum remove $service_to_chk -y
#systemctl disable $service_to_chk

output="$(ps -ef | egrep $service | grep -v grep| awk '{print $2}')"
# output="$(ps -ef | egrep taco| grep -v grep| awk '{print $2}')"

if [[ -n $output ]]
then
    echo -e "\n server: `hostname` \n OS is $os1 \n $service service IS running!! " | /bin/mail -s "Server: `hostname` $service running... os is $os1 " $dist_list
    # echo " -- output $output"
else
    echo -e "\n server: `hostname` \n OS is $os1 \n  $service service IS NOT running!! " | /bin/mail -s "Server: `hostname` $service NOT running... os is $os1 " $dist_list
    # echo " -- No output $output"
fi

# if [[ $swpid -gt 1 ]]
if [[ $swpid == 0 ]]
then
     echo " it's running "
#     echo -e "\n server: `hostname` \n OS is $os1 \n $service service IS running!! " | /bin/mail -s "Server: `hostname` $service running... os is $os1 " $dist_list
  else
  #   echo -e "\n server: `hostname` \n OS is $os1 \n  $service service IS NOT running!! " | /bin/mail -s "Server: `hostname` $service NOT running... os is $os1 " $dist_list
     echo " it's NOT running "
fi

