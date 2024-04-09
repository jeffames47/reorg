#!/bin/bash
# Last modified: Mon Feb 14 16:24:33 CST 2022
# dist_list=jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,Benny.Butler@navihealth.com,Chad.Binkley@navihealth.com
# export dist_list=jeffrey.ames@navihealth.com
   dist_list=jeffrey.ames@navihealth.com
# dist_list=jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,Bruce.Jackson@navihealth.com,Chad.Binkley@navihealth.com


######## global variables:

pid_coun=t$(ps -ef | egrep $service | egrep -v grep | wc -l)
pid=$(ps -ef | egrep $service | awk '{print $2}')
service_chk_centos6_wc=`ps -ef | grep $service | grep -v grep | wc -l`
export os1=$(grep -Eo '[0-9]{1,4}' /etc/redhat-release|head -n1)
hst=`hostname`


############# fuctions

check_service_running() {
if [[ $os1 == 7 ]]
then
    service_chk_wc=`systemctl status $service | grep active | grep running | wc -l`
else
    service_chk_wc=`service $service status | grep running | wc -l`
fi

if [[ $service_chk_wc == 0 ]]
  then
    sh -c "false; exit 0" ; echo $?
    echo -e "\n Server: $hst    Service: $service is down." | /bin/mail -s " 'WARNING' `date +%m%d%y%H%M` Server: $hst Service: $service is down. " $dist_list
  else
    sh -c "false" ; echo $?
    echo -e "\n Server: $hst Service: $service is.....  UP!!!!!!" | /bin/mail -s " `date +%m%d%y%H%M` Server: $hst Service: $service is ........INSTALLED and UP!!!!!!!. " $dist_list
fi
}


##################################   main    ##########################################

# DEBUG=$1
service=docker

cd /tmp

yum install mailx -y
# echo "yum install mailx -y"

yum install -y yum-utils
# echo "yum install -y yum-utils"

mkdir -p /etc/docker && echo {\"bip\":\"10.5.2.1/24\"} >> /etc/docker/daemon.json
# echo " mkdir -p /etc/docker && echo {\"bip\":\"10.5.2.1/24\"} >> /etc/docker/daemon.json "

cd /etc/pki/ca-trust/source/anchors && curl -O http://devopsfiles.navidev.local/centos/odd_files_and_scripts/cacert.crt && sed -i '1d' cacert.crt && update-ca-trust
# echo " cd /etc/pki/ca-trust/source/anchors && curl -O http://devopsfiles.navidev.local/centos/odd_files_and_scripts/cacert.crt && sed -i '1d' cacert.crt && update-ca-trust "

curl https://releases.rancher.com/install-docker/19.03.sh | sh
# echo " curl https://releases.rancher.com/install-docker/19.03.sh | sh "

systemctl enable docker
# echo " systemctl enable docker "

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
# echo "yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo"

sudo yum install -y docker-ce
# echo " sudo yum install -y docker-ce "
sudo yum install -y docker-ce-cli
# echo " sudo yum install -y docker-ce-cli  "
sudo yum install -y containerd.io
# echo " sudo yum install -y containerd.io "

sudo systemctl start docker
# echo "sudo systemctl start docker"

check_service_running

exit
