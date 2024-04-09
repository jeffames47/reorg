#!/bin/bash
# This script with fix ldap
# Last modified: Wed 11/2 

# global variables
## export dist_list=jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,benny.butler@navihealth.com
## export dist_list=jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com
export dist_list=jeffrey.ames@navihealth.com

######################### Functions ####

check_n_email() {
domain_chk=`realm list | grep ad.curaspan.local | wc -l`
if [[ $domain_chk -gt 0 ]]
    then
        # echo " it's curaspan do nothing"
        echo -e "\n server: `hostname` \n domain was set to ad.curaspan.local successfully!! " | /bin/mail -s " `date +%m%d%y%H%M` `hostname`domain was set to ad.curaspan.local successfully! " $dist_list
    else
        echo -e "\n server: `hostname` \n domain was NOT set to curaspan!! Investigate" | /bin/mail -s " `date +%m%d%y%H%M` `hostname` domain was NOT set to curaspan! investigate.  " $dist_list
fi
}


######################### main script #####################################################

#export PW=WellSky2022
#echo   "  echo $PW | realm join --user=svc_realm ad.curaspan.local --membership-software=adcli"
#echo $PW | realm join --user=svc_realm ad.curaspan.local --membership-software=adcli


systemctl stop firewalld
systemctl disable firewalld

#  overlay selinux  
selinux=/etc/selinux/config
cat << EOF > /etc/selinux/config
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=disabled
# SELINUXTYPE= can take one of three values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected.
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
EOF

#  check_n_email

exit
