#!/bin/bash
# this small script will do some work for high trust with certs
# Last modified: Feb 3 2021
export dist_list=jeffrey.ames@navihealth.com,BMW.Suwannakat@navihealth.com,luis.arce@navihealth.com
export dist_list=jeffrey.ames@navihealth.com,BMW.Suwannakat@navihealth.com

logfile='/var/log/cert_install'
if [[ ! -f $logfile ]];
then
  touch $logfile
else
  echo "The log file exists"
fi

debug=$1
os1=$(grep -Eo '[0-9]{1,4}' /etc/redhat-release|head -n1)
if [[ ${debug} = d ]]
then
  echo -e "\n \n Debug mode... os1 is $os1 \n " | tee -a $logfile
fi
if [[ $os1 == 5 ]]
then
  echo -e "\nThis VM is CentOS 5" | tee -a $logfile
  cd /etc/yum.repos.d/ | tee -a $logfile
  echo -e "\nGetting the base repo for CentOS 5" | tee -a $logfile
  curl -O http://10.10.120.180/centos/odd_files_and_scripts/files/CentOS-Base.repo
  echo "" | tee -a $logfile
  cd /etc/pki
  sleep 3
  echo -e "Performing a 'yum clean all'" | tee -a $logfile
  echo "" | tee -a $logfile
  yum clean all
  echo "" | tee -a $logfile
  yum update openssl nss -y | tee -a $logfile
fi

cd /etc/pki
echo -e "\nGetting the new cert file" | tee -a $logfile
curl -O http://10.10.120.180/centos/odd_files_and_scripts/cacert.crt
echo -e "\nGetting the hash values for the files" | tee -a $logfile
hash1=$(md5sum /etc/pki/tls/certs/ca-bundle.crt | awk '{print $1}')
hash2=$(md5sum /etc/pki/ca-bundle.crt | awk '{print $1}')
echo -e "\nHash 1 for $(hostname): $hash1" | tee -a $logfile
echo -e "\nHash 2 for $(hostname): $hash2" | tee -a $logfile
if [[ $hash1 == $hash2 ]]
then
  echo -e "\nThe md5 hash says files are the same, exiting" | tee -a $logfile
  echo -e "\nThe md5 hash says files are the same, exiting" | mail -s "investigate root cert for $(hostname). md5 is the same " $dist_list
  exit 5
 echo $?
fi

sleep 2

        case $os1 in
                5)      echo -e "\n OS is 5, Making copy of the bundled cert file, and dropping in a known working one" | tee -a $logfile
                        echo -e "\nMaking copy of the cert file and removing the old one" | tee -a $logfile
                        cp tls/certs/ca-bundle.crt tls/certs/ca-bundle.crt.bkup
                        rm tls/certs/ca-bundle.crt -f
                        cp ca-bundle.crt tls/certs
                        echo
                        ;;
                6)      echo -e "\n OS is 6 so copy a file and run a command and do some other junk" | tee -a $logfile
                        echo -e "\nInstalling the package 'ca-certificates'" | tee -a $logfile
                        yum install ca-certificates -y
                        update-ca-trust force-enable
                        yes | cp cacert.crt /etc/pki/ca-trust/source/anchors
                        update-ca-trust extract
                        echo
                        ;;
                7)      echo -e "\n OS is 7 so copy a file and run a command and do some other junk" | tee -a $logfile
                        echo -e "\nInstalling the package 'ca-certificates'" | tee -a $logfile
                        yum install ca-certificates -y
                        update-ca-trust force-enable
                        yes | cp cacert.crt /etc/pki/ca-trust/source/anchors
                        update-ca-trust extract
                        echo
                        ;;
                *)      echo -e "\nInvalid" | tee -a $logfile
                        ;;
        esac
    shift `expr $OPTIND - 1`

if [[ $hash1 -ne $hash2 ]]
then
    echo -e "For host $(hostname) the root cert looks good! " | mail -s "$(hostname) root cert looks good!!! " $dist_list | tee -a $logfile
else
        echo -e "For host $(hostname) the root cert looks bad. " | mail -s "investigate root cert for $(hostname). md5 is the same " $dist_list | tee -a $logfile
fi

exit 0
