#!/bin/bash
# Last modified: Tue Dec 1 11:57:16 CDT 2020

### global vars

# dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,Benny.Butler@navihealth.com,Chad.Binkley@navihealth.com
# dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Chad.Binkley@navihealth.com
 dist_list=jeffrey.ames@navihealth.com

debug=$1

if [[ $debug = d || $debug = D ]]; then
    echo "At start. Running $0 on `hostname` at `date` "
fi

cp /etc/ntp.conf /etc/ntp_bkup.conf

y | yum install ntp
y | yum install firewalld
firewall-cmd --permanent --add-service=ntp
firewall-cmd --complete-reload
service firewalld restart
#  /bin/systemctl start firewalld.service
sleep 1
systemctl restart firewalld
sleep 1
systemctl stop ntpd
sleep 1
ntpdate va-dc-01.navihealth.local
systemctl start ntpd
sleep 1
/sbin/ntpq -p

if [[ $debug = d || $debug = D ]]; then
    echo "At end. Running $0 on `hostname` at `date` "
fi

exit 0

