#!/bin/bash
# This script with leave the realm, join the curaspan realm then verify it is in the curaspan realm and send notificaition
# Last modified: Wed Aug 17 09:26:26 EST 2022

# global variables
###   export dist_list=jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,benny.butler@navihealth.com
export dist_list=jeffrey.ames@navihealth.com
export dist_list=jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com

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

#realm list
#echo " ptt1  PW is $PW"

realm leave navidev.local 2> /dev/null
sleep 1

realm leave navihealth.local 2> /dev/null
sleep 1

export PW=WellSky2022
#echo   "  echo $PW | realm join --user=svc_realm ad.curaspan.local --membership-software=adcli"
echo $PW | realm join --user=svc_realm ad.curaspan.local --membership-software=adcli

#realm list

## extra stuff below is sssd FDQN fix and not really realm related

#  over lay /etc/sssd/sssd.conf
chmod 666 /etc/sssd/sssd.conf
sssd_file=/etc/sssd/sssd.conf
cat << EOF > /etc/sssd/sssd.conf
[sssd]
domains = ad.curaspan.local
config_file_version = 2
services = nss, pam
# END ANSIBLE MANAGED BLOCK

[domain/ad.curaspan.local]
ad_domain = ad.curaspan.local
krb5_realm = AD.CURASPAN.LOCAL
realmd_tags = manages-system joined-with-adcli
cache_credentials = True
id_provider = ad
krb5_store_password_if_offline = True
default_shell = /bin/bash
ldap_id_mapping = False
use_fully_qualified_names = False
fallback_homedir = /home/%u
access_provider = ad
EOF

#  over lay /etc/sssd/sssd.conf
chmod 666 /etc/krb5.conf
sssd_file=/etc/krb5.conf
cat << EOF > /etc/krb5.conf
# Configuration snippets may be placed in this directory as well
includedir /etc/krb5.conf.d/

includedir /var/lib/sss/pubconf/krb5.include.d/
[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[libdefaults]
 dns_lookup_realm = false
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true
 rdns = false
 pkinit_anchors = /etc/pki/tls/certs/ca-bundle.crt
# default_realm = EXAMPLE.COM
 default_ccache_name = KEYRING:persistent:%{uid}

 default_realm = AD.CURASPAN.LOCAL
[realms]
# EXAMPLE.COM = {
#  kdc = kerberos.example.com
#  admin_server = kerberos.example.com
# }

 AD.CURASPAN.LOCAL = {
 }

[domain_realm]
# .example.com = EXAMPLE.COM
# example.com = EXAMPLE.COM
 ad.curaspan.local = AD.CURASPAN.LOCAL
 .ad.curaspan.local = AD.CURASPAN.LOCAL
EOF

systemctl restart sssd
sleep 1

/etc/init.d/network restart
sleep 1

# cd /etc/yum.repos.d/ ; mv * /tmp ; cp /tmp/CentOS-Base.repo . ;  yum install -y yum-utils
#  optional
#  set up or fix /etc/sysconfig/network-scripts/ifcfg-ens192

# create /root/.cifscreds for mounts
# echo "username=edisdocsadmin" > /root/.cifscreds
# echo "password=s-(1&5b0)c=Z3" >> /root/.cifscreds

check_n_email

exit

