#!/bin/bash
#############################################a#######################################################
# This script will: 
#   * check space, if issue do not perform a patch and email on >95%. 
#   * check and change nic info
#   * add ansible user
# Last modified: Fri Apr 24 10:52:01 CDT 2020 
#####################################################################################################

######## global variables:

export hst=`hostname`
# dist_list=operations@navihealth.com
# dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,Benny.Butler@navihealth.com,Chad.Binkley@navihealth.com
# dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Chad.Binkley@navihealth.com
export dist_list=jeffrey.ames@navihealth.com
export high_space_limit=88
adapter='echo "$(locate -i ifcfg-e |  grep -v bak)"'
workdir="/etc/sysconfig/network-scripts"
working_dir="/tmp/patchCheck"
export usr="root"
export output_file=test_sudoers
export add_ansible_user_chk_1=yes
export add_ansible_user_chk_2=yes

######## functions

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

### This function will check space
function check_space() {
df -H | grep -vE '^Filesystem|tmpfs|cdrom|mnt' | awk '{ print $5 " " $1 }' | while read output;
do
    usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
    partition=$(echo $output | awk '{ print $2 }' )
    if [ $usep -ge $high_space_limit ]; then
        if [[ ${debug} == d ]]
        then
            echo "Running out of space for server: $hst  \"$partition ($usep%)\" as of $(date)"
        fi
        echo -e "\n Running out of space for server: $hst \"$partition ($usep%)\" as of $(date) \n Removing a couple logs" | /bin/mail -s " 'WARNING' `date +%m%d%y%H%M` host: $hst running out of space \"$partition ($usep%)\" as of $(date) " $dist_list
        rm -f /var/log/maillog-*20* > /dev/null 2>&1
        rm -f /var/log/messages-*20* > /dev/null 2>&1
        rm -f /var/log/cron-*20* > /dev/null 2>&1
        rm -f /var/log/secure-*20* > /dev/null 2>&1
        rm -f /var/log/spooler-*20* > /dev/null 2>&1
    fi
done
} ########### end of check_space

### This function will change the nic settings
function change_nic_settings() {
    cd /etc/sysconfig/network-scripts
    export nic=`locate -i ifcfg-e | grep -v bak| grep -v bkup`
    sed -i s/BOOTPROTO=yes/BOOTPROTO=static/g $nic
    sed -i s/PEERDNS=no/PEERDNS=yes/g $nic
} ############## end change_nic_settings

### This function will add the ansible user
function add_ansible_user() {
    export dusr='ansible'
    export dkey="~ansible/.ssh/authorized_key"
    useradd ansible 2>/dev/null
    sleep 1
    echo ansible:Nav1Automation2018 | chpasswd 2>/dev/null
    sleep 1
    usermod -aG wheel ansible 2>/dev/null
    sleep 1
    id ansible 2>/dev/null
    sleep 1
    echo "Defaults:ansible !requiretty" >> /etc/sudoers
    sleep 1
    echo "ansible ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
    sleep 1
    chown $dusr:$dusr $dkey 2>/dev/null
} ####### done add_ansible_user


########################### main #################################

debug=$1

while read -r eachline
do
    this=$(echo "$eachline")
    first=$(echo "$eachline" | awk '{print $1}')
    second=$(echo "$eachline" | awk '{print $2}')
    #echo "this is:   ${this} "
    #echo "first: ${first} "
    second=$(echo "$eachline" | awk '{print $2}')
    #echo "second: ${second} "
    data1_to_check="Defaults:ansible !requiretty"

    if [ "${this}" = "${data1_to_check}" ]; then
        echo -e "\n data1_to_check is found   ${data1_to_check}  do NOT perform ansible user add" 
        export add_ansible_user_chk_1=no
    else
        continue
    fi
    if [ "${first}" = "ansible" ]; then
        echo " ansible user found ${first}  do NOT add ansible user "
        export add_ansible_user_chk_2=no
    else
        continue
    fi
done < "/etc/sudoers"

if [[ ${add_ansible_user_chk_1} == yes && ${add_ansible_user_chk_2} == yes ]]; then
    #echo " adding ansible user ${add_ansible_user_chk_1} ${add_ansible_user_chk_2}" 
    add_ansible_user
fi

  check_space

  change_nic_settings

exit 0
