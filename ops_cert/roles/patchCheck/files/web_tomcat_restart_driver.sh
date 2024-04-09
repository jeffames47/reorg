#!/bin/bash 
# just a simple loop to restart tomcat and run a web process then check if all is well.  if issues exit 
# Last modified: Fri May  5 08:40:45 EST 2023

####### functions  #####


check_n_exit() {
export service=tomcat8
cd /tmp
mv -f /tmp/tmp_status_* /tmp/tmpstatustoremove 2> /dev/null
export a=`cat /tmp/tmpstatustoremove | awk '{split($0,a,"_"); print a[3] a[2] a[1]}'`
## echo " a is $a"
export webserver=`cat /tmp/tmpstatustoremove | awk '{split($0,a,"_"); print a[1]}'`
## echo "webserver is $webserver"
export status=`cat /tmp/tmpstatustoremove | awk '{split($0,a,"_"); print a[2]}'`
## echo "status is $status"
## echo -e "\n server: $webserver status is $status  "

if [[ ${status} == UP || ${status} == up ]]
  then
    # echo -e "\n UP so continue"
    # echo -e "\n server: $webserver status is $status  "
    sleep 1
  else
    # echo -e "\n DOWN so exiting"
    # echo -e "\n server: $webserver status is $status !  investigate ASAP ! "
    exit
fi
# cleanup
 rm -rf /tmp/tmp_status_*
 rm -rf /tmp/tmpstatusto*
}


###################### main ##############################


### below block of code is just for testing 
cd /home/james/ops_cert
#check_n_exit
ansible-playbook /home/james/ops_cert/restarttomcat_dev3.yml --extra-vars "applicationVar=Appl_jeff envVar=Env_DV" -i /home/james/ops_cert/inventory/misc/pr/vavpr-web-01.ini
echo " 3 is done running check_n_exit submodule" 
sleep 2
check_n_exit
sleep 120
ansible-playbook /home/james/ops_cert/mail.yml --extra-vars "applicationVar=Appl_jeff envVar=Env_DV" -i /home/james/ops_cert/inventory/misc/pr/dvbosljeffa01.ini

echo " 1 is done  tryin 04  with .ini files" 
ansible-playbook /home/james/ops_cert/restarttomcat_dev3.yml --extra-vars "applicationVar=Appl_jeff envVar=Env_DV" -i /home/james/ops_cert/inventory/misc/pr/vavpr-web-02.ini
echo " 4 is done going to run mail  " 
sleep 2
check_n_exit
sleep 120
ansible-playbook /home/james/ops_cert/mail.yml --extra-vars "applicationVar=Appl_jeff envVar=Env_DV" -i /home/james/ops_cert/inventory/misc/pr/dvbosljeffa01.ini

rm -f /tmp/tmp_status_*
rm -f /tmp/tmpstatusto*

