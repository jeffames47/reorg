#!/bin/bash
############################################a#######################################################
# This script will check space, and not perform a patch if >95%.
# Last modified: Tue Jun 30 13:00:38 EST 2020
####################################################################################################

######## global variables:

export hst=`hostname`
export high_space_limit=98
### note: this is about 1G  900024 for /
export high_gig=990024
export dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Chad.Binkley@navihealth.com
   export dist_list=jeffrey.ames@navihealth.com

###### check % full on certain disks ###
function chk_percent() {
df -H | grep -vE '^Filesystem|tmpfs|cdrom|mnt' | awk '{ print $5 " " $1 }' | while read output;
do
    usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
    partition=$(echo $output | awk '{ print $2 }' )
    if [ $usep -ge $high_space_limit ]; then
        if [[ ${debug} == d ]]
        then
            echo -e "\n Running out of space for server: $hst \"$partition ($usep%)\" as of $(date) \n \n high limit is: $high_space_limit \n \n Removing a couple logs"
        fi
        echo -e "\n Running out of space for server: $hst \"$partition ($usep%)\" as of $(date) \n \n high limit is: $high_space_limit \n \n Removing a couple logs check and/or remove space on / and try to patch again" | /bin/mail -s " 'WARNING' `date +%m%d%y%H%M` host: $hst running out of space \"$partition ($usep%)\" " $dist_list
        rm -f /var/log/maillog-*20* > /dev/null 2>&1
        # rm -f /var/log/messages-*20* > /dev/null 2>&1
        rm -f /var/log/cron-*20* > /dev/null 2>&1
        rm -f /var/log/secure-*20* > /dev/null 2>&1
        rm -f /var/log/spooler-*20* > /dev/null 2>&1
    fi
done
}

### check for 1G avail on / ###
function chk_1G() {
#  check /
df -k | awk '{ print $4 " " $6 }' | while read output;
do
    export gig=$(echo $output | awk '{ print $1 }' )
    partition=$(echo $output | awk '{ print $2 }' )
        if [[ ${partition} == / ]]; then
            gig=`expr $gig + 1`
            high_gig=`expr $high_gig + 1`
            if (( $gig < $high_gig )); then
                if [[ ${debug} == d ]]
                then
                    echo -e "\n partition: ${partition}      gig: $gig  high_gig: $high_gig "
                    echo "Running out of space for server: $hst for partition:  \"$partition ($gig)\" as of $(date)"
                    echo -e "\n Not enough Gig to perform patch for server: $hst  on: $partition as of $(date) \n \n Availiable space is only $gig and we need $high_gig to patch  \n Try to delete a couple large logs or file prior to patching "
                    echo "Running out of space for server: $hst for partition:  \"$partition ($gig)\" as of $(date)"
                fi
                    echo -e "\n Not enough Gig to perform patch for server: $hst  on: $partition as of $(date) \n \n Availiable space is only $gig and we need $high_gig to patch (about 1G)  \n Try to delete a couple large logs or file prior to patching " | /bin/mail -s " 'WARNING' host: $hst not enough Gig avaiable for \"$partition\" " $dist_list
            fi
        else
          if [[ ${debug} == d ]]
          then
             echo "         non root so i do not care    $hst for partition:  \"$partition \" as of $(date)"
          fi
        fi
done

#  check /boot
export high_gig=44360
df -k | awk '{ print $3 " " $4 " " $6 }' | while read output;
do
    export gig=$(echo $output | awk '{ print $1 }' )
    partition=$(echo $output | awk '{ print $3 }' )
    echo " gig is $gig     partition is $partition " 
        if [[ ${partition} == /boot ]]; then
            gig=`expr $gig + 0`
            high_gig=`expr $high_gig + 0`
            if (( $gig < $high_gig )); then
                if [[ ${debug} == d ]]
                then
                    echo -e "\n partition: ${partition}      gig: $gig  high_gig: $high_gig "
                    echo "Running out of space for server: $hst for partition:  \"$partition ($gig)\" as of $(date)"
                    echo -e "\n Not enough Gig to perform patch for server: $hst  on: $partition as of $(date) \n \n Availiable space is only $gig and we need $high_gig to patch  \n Try to delete a couple large logs or file prior to patching "
                    echo "Running out of space for server: $hst for partition:  \"$partition ($gig)\" as of $(date)"
                fi
                    echo -e "\n Not enough Gig to perform patch for server: $hst  on: $partition as of $(date) \n \n Availiable space is only $gig and we need $high_gig to patch (about 1G)  \n Try to delete a couple large logs or file prior to patching " | /bin/mail -s " 'WARNING' host: $hst not enough Gig avaiable for \"$partition\" " $dist_list
            fi
        else
          if [[ ${debug} == d ]]
          then
             echo "         non root so i do not care    $hst for partition:  \"$partition \" as of $(date)"
          fi
        fi
done
}

############################ main #################################

debug=$1

chk_percent

chk_1G

exit 0
