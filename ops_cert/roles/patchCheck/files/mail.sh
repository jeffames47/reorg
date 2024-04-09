#!/bin/bash
# Last modified:  may 8 1:06
#  export dist_list=jeffrey.ames@wellsky.com,Luis.Arce@wellsky.com,roshni.patel@careporthealth.com
# export dist_list=jeffrey.ames@wellsky.com,Luis.Arce@wellsky.com
export dist_list=jeffrey.ames@wellsky.com


cd /tmp
rm -f /tmp/tmpstatustoremove 2> /dev/null
touch /tmp/tmpstatustoremove 2> /dev/null
## cp -f /tmp/tmp_status* /tmp/tmpstatustoremove
cat /tmp/tmp_status_* > /tmp/tmpstatustoremove 2> /dev/null

export a=`cat /tmp/tmpstatustoremove | awk '{split($0,a,"_"); print a[3] a[2] a[1]}'`
##echo " a is $a"
export webserver=`cat /tmp/tmpstatustoremove | awk '{split($0,a,"_"); print a[1]}'`
##echo "webserver is $webserver"
##status=`cat /tmp/tmp_status_UP_vavpr-web-01.curaspan.local | awk '{split($0,a,"_"); print a[2]}'`
export status=`cat /tmp/tmpstatustoremove | awk '{split($0,a,"_"); print a[2]}'`
##echo "status is $status"
##echo -e "\n server: $webserver status is $status  "

if [[ ${status} == UP || ${status} == up ]]
  then
    echo -e "\n UP continue"
    echo -e "\n server: $webserver status is $status  " | /bin/mail -s "Server: $webserver status is $status " $dist_list
    sleep 1
    #rm -rf /tmp/tmp_status_*
    #rm -rf /tmp/tmpstatusto*
  else
    echo -e "\n DOWN exiting"
    echo -e "\n server: $webserver status is $status ! " | /bin/mail -s "Server: $webserver status is $status !!!  " $dist_list
    sleep 1
    #rm -rf /tmp/tmp_status_*
    #rm -rf /tmp/tmpstatusto*
fi

## cleanup
sleep 1
rm -f /tmp/tmp_status_*
rm -f /tmp/tmpstatusto*

exit
