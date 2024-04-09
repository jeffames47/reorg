#!/bin/bash
###################################################################################
# This script will check add the ansible user
# Last modified: Thu Apr 23 15:22:27 CDT 2020
###################################################################################

export dusr='ansible'
export dkey="~ansible/.ssh/authorized_key"
export add_ansible_user_chk1=yes
export add_ansible_user_chk2=yes

### This function will add the ansible user
function add_ansible_user() {
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
    data1_to_check="Defaults:ansible !requiretty"

    if [ "${this}" = "${data1_to_check}" ]; then
        export add_ansible_user_chk1=no
    else
        continue
    fi
    if [ "${first}" = "ansible" ]; then
        export add_ansible_user_chk2=no
    else
        continue
    fi
done < "/etc/sudoers"

if [[ ${add_ansible_user_chk1} == yes && ${add_ansible_user_chk2} == yes ]]; then
    add_ansible_user
fi

exit 0

