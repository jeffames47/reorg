#!/bin/bash
############################################a#######################################################
# This script will comment out the newcache line in the fstab and restart tomcat 
# Last modified: Wed Jan 6 15:00:38 EST 2020
############################################a#######################################################

#  dist_list=jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,bruce.jackson@navihealth.com,Chad.Binkley@navihealth.com
#  dist_list=jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com
#   dist_list=jeffrey.ames@navihealth.com

#service=tomcat6

mkdir -p /tmp/transition/
mkdir -p /tmp/discharge/

cp -p /mnt/dc2share/transition/cred.xml /tmp/transition/
cp -p /mnt/dc2share/discharge/cred.xml /tmp/discharge/
cp -rp /mnt/dc2share/forms /tmp

umount /mnt/dc2share

if [[ ! -d /mnt/dc2share/forms ]];
  then rm -rf /mnt/dc2share/forms
fi

cp /etc/fstab /tmp/fstab.bkup

# testing    sed -ie "s/\(.*newcache*\)/#\1/" /home/james/ops_cert/test_fstab_comment
sed -ie "s/\(.*newcache*\)/#\1/" /etc/fstab

mkdir /mnt/dc2share/transition/
mkdir /mnt/dc2share/discharge/

chown root:creds /mnt/dc2share/transition
chown root:creds /mnt/dc2share/discharge

cp -fp /tmp/transition/cred.xml /mnt/dc2share/transition/
cp -fp /tmp/discharge/cred.xml /mnt/dc2share/discharge/

cp -rp /tmp/forms /mnt/dc2share/
#rm -rf /tmp/forms

