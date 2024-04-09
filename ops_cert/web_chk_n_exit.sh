#!/bin/bash
# Last modified: Wed Feb  8 08:58:27 CST 2023
 export dist_list=jeffrey.ames@navihealth.com,jeffrey.ames@wellsky.com
########  dist_list=jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,bruce.jackson@navihealth.com
 export dist_list=jeffrey.ames@wellsky.com

export service=tomcat8
cd /tmp

mv -f /tmp/tmp_status_* /tmp/tmpstatustoremove 2> /dev/null

export a=`cat /tmp/tmpstatustoremove | awk '{split($0,a,"_"); print a[3] a[2] a[1]}'`
##echo " a is $a"
export webserver=`cat /tmp/tmpstatustoremove | awk '{split($0,a,"_"); print a[1]}'`
echo "webserver is $webserver"
# status=`cat /tmp/tmp_status_UP_vavpr-web-01.curaspan.local | awk '{split($0,a,"_"); print a[2]}'`
export status=`cat /tmp/tmpstatustoremove | awk '{split($0,a,"_"); print a[2]}'`
echo "status is $status"
echo -e "\n server: $webserver status is $status  "
# echo -e "\n server: $webserver status is $status  " | /bin/mail -s "Server: $webserver status is $status " $dist_list

if [[ ${status} == UP || ${status} == up ]]
  then
    echo -e "\n UP continue"
    echo -e "\n server: $webserver status is $status  " 
    sleep 1
  else
    echo -e "\n DOWN exiting"
    echo -e "\n server: $webserver status is $status !  investigate ASAP ! " 
     exit
fi

# cleanup
# rm -rf /tmp/tmp_status_*
# rm -rf /tmp/tmpstatusto*

exit
