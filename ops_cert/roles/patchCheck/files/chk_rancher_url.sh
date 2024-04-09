#!/bin/bash
#export dist_list=jeffrey.ames@navihealth.com,david.martin@navihealth.com,richard.gu@navihealth.com,mohan.Shrestha@navihealth.com,gary.potagal@navihealth.com
export dist_list=jeffrey.ames@navihealth.com

url_stub=$1
service=$2
echo "url_stub is $url_stub"
curl_code=$(curl -o /dev/null -u myself:XXXXXX -Isw '%{http_code}\n' https://rancher-bos.curaspan.local/dashboard/home --insecure)
echo " ptt1 curl_code $curl_code" 
curl_code=$(curl -o /dev/null -u myself:XXXXXX -Isw '%{http_code}\n' https://$url_stub.curaspan.local/dashboard/home --insecure)
echo " ptt2 curl_code $curl_code" 

export os1=$(grep -Eo '[0-9]{1,4}' /etc/redhat-release|head -n1)
#service_chk_wc=`ps -ef | grep splunk |  egrep -v grep | wc -l`
hst=`hostname`

if [[ $curl_code == 200 ]]
  then
    echo -e "\n URL $url_stub is UP !! root is ` df -h / | tail -1 ` " | /bin/mail -s " 'UP' `date +"%T"` `date +"%m-%d-%y" ` Server: $hst $url_stub is UP !!! " $dist_list
  else
    echo -e "\n URL $url_stub is DOWN !! root is ` df -h / | tail -1 ` " | /bin/mail -s " 'DOWN' `date +"%T"` `date +"%m-%d-%y" ` Server: $hst $url_stub is DOWN!!! " $dist_list
fi

exit

