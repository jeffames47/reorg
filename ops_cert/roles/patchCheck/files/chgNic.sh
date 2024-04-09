#!/bin/bash
#####################################################################################
# This script will fix the nic
# Last modified: Thu Apr 16 10:04:33 CDT 2020
# usage :  nic_chg.sh <before or after> <password>  [d]
#####################################################################################

#### global variables:

export hst=`hostname`
# dist_list=operations@navihealth.com
# dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Chad.Binkley@navihealth.com
export dist_list=jeffrey.ames@navihealth.com
export adapter='echo "$(locate -i ifcfg-e |  grep -v bak)"'
export workdir="/etc/sysconfig/network-scripts"
export usr="root"

#### functions

function change_nic_settings() {
    cd /etc/sysconfig/network-scripts
    export nic=`locate -i ifcfg-e | grep -v bak| grep -v bkup`
    sed -i s/BOOTPROTO=yes/BOOTPROTO=none/g $nic
    sed -i s/PEERDNS=no/PEERDNS=yes/g $nic
} ##### end change_nic_settings

###################### main ########################

export cmd2="cat $adapter"
export sshopts='-oConnectTimeout=5 -oStrictHostKeyChecking=no -p 22 -q'

export hosts_to_patch=${hst}
### export hosts_to_patch=$2
debug=$1

if [[ ${debug} = d ]]
then
    echo -e "\n Debug mode!  At `date '+%Y-%m-%d %H:%M:%S'` : B4_OR_AFTER is: $B4_OR_AFTER"
    echo -e "\n cmd2 $cmd2"
    echo -e "\n  adaper $adapter"
    echo -e "\n dist_list $dist_list"
    echo -e "\n adapter $adapter"
    echo -e "\n workdir $workdir"
    echo -e "\n usr $usr"
fi

change_nic_settings

exit 0
