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
[root@mavsg-twradm-04 files]# cat service_chk_and_restart.sh
#!/bin/bash
# This small script will: check ssh and restart it if it is not running
# Last modified: Dec 1 13:07:16 CDT 2020


########### functions

chk_and_start_cf() {
    /etc/init.d/coldfusion9 $action
}

chk_and_start_ntpd() {
export service_to_chk=ntpd
if [[ $os1 == 7 ]]
then
    service_chk=`systemctl status $service_to_chk | grep running | wc -l`
        if [[ $service_chk_wc -ge 1 ]]
        then
            echo " it's running do nothing"
        else
            systemctl restart $service_to_chk
        fi
else
    service_chk=`systemctl status $service_to_chk | grep running | wc -l`
        if [[ $service_chk_wc -ge 1 ]]
    #service_chk_wc=`service $service_to_chk status| grep running`
    #    if [[ $service_chk_wc -ge 1 ]] ;
        then
            echo " it's running do nothing"
        else
            service $service_to_chk start
        fi
fi
}

chk_and_start_ssh() {
if [[ $os1 == 7 ]]
then
    service_to_chk=sssd
    service_to_chk=ssh
    service_chk=`systemctl status sssd | grep running`
        if [[ $service_chk_wc -ge 1 ]]
        then
            echo " it's running do nothing"
        else
            systemctl restart sssd
        fi
else
    service_to_chk=ssh
    service_chk=`service sshd status`
        if [[ $service_chk_wc -ge 1 ]]
        then
            echo " it's running do nothing"
        else
            service sshd restart
        fi
fi
}

############### main ##############

#echo -e "\n    in check_url performing healthcheck"
export os1=$(grep -Eo '[0-9]{1,4}' /etc/redhat-release|head -n1)
#echo " os1 is $os1"

export action=start
#chk_and_start_ssh
#service_to_chk=coldfusion
#chk_and_start_cf
service_to_chk=ntpd
chk_and_start_ntpd

exit 0
