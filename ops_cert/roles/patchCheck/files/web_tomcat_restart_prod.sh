#!/bin/bash 
# just a simple loop to run a web process then check if all is well.  if issues exit 
# Last modified: Fri May  5 08:40:45 EST 2023

####### functions 

check_n_exit() {
export service=tomcat8
cd /tmp
touch /tmp/tmpstatustoremove 2> /dev/null
mv -f /tmp/tmp_status_* /tmp/tmpstatustoremove 2> /dev/null
export a=`cat /tmp/tmpstatustoremove | awk '{split($0,a,"_"); print a[3] a[2] a[1]}'`
##echo " a is $a"
export webserver=`cat /tmp/tmpstatustoremove | awk '{split($0,a,"_"); print a[1]}'`
##echo "webserver is $webserver"
## status=`cat /tmp/tmp_status_UP_vavpr-web-01.curaspan.local | awk '{split($0,a,"_"); print a[2]}'`
export status=`cat /tmp/tmpstatustoremove | awk '{split($0,a,"_"); print a[2]}'`
## echo "status is $status"
## echo -e "\n server: $webserver status is $status  "

#echo " status is $status "
#echo " status is $status "

if [[ ${status} == UP || ${status} == up ]]
  then
    # echo -e "\n    UP so continue"
    # echo -e "\n    server: $webserver status is $status  "
    sleep 1
  else
    # echo -e "\n    DOWN so exiting"
    # echo -e "\n    server: $webserver status is $status !  investigate ASAP ! "
    sleep 1
    exit
fi
sleep 2
# cleanup
}


###################### main ##############################

cd /home/james/ops_cert
ansible-playbook /home/james/ops_cert/restarttomcat_dev4.yml --extra-vars "applicationVar=Appl_jeff envVar=Env_DV" -i /home/james/ops_cert/inventory/misc/pr/vavpr-web-01.ini
sleep 32
check_n_exit
sleep 12
ansible-playbook /home/james/ops_cert/mail.yml --extra-vars "applicationVar=Appl_jeff envVar=Env_DV" -i /home/james/ops_cert/inventory/misc/pr/dvbosljeffa01.ini
sleep 2

#cd /home/james/ops_cert
#ansible-playbook /home/james/ops_cert/restarttomcat_dev4.yml --extra-vars "applicationVar=Appl_jeff envVar=Env_DV" -i /home/james/ops_cert/inventory/misc/pr/vavpr-web-02.ini
#sleep 32
#check_n_exit
#sleep 12
#ansible-playbook /home/james/ops_cert/mail.yml --extra-vars "applicationVar=Appl_jeff envVar=Env_DV" -i /home/james/ops_cert/inventory/misc/pr/dvbosljeffa01.ini
#sleep 2

#cd /home/james/ops_cert
#ansible-playbook /home/james/ops_cert/restarttomcat_dev4.yml --extra-vars "applicationVar=Appl_jeff envVar=Env_DV" -i /home/james/ops_cert/inventory/misc/pr/vavpr-web-03.ini
#sleep 32
#check_n_exit
#sleep 12
#ansible-playbook /home/james/ops_cert/mail.yml --extra-vars "applicationVar=Appl_jeff envVar=Env_DV" -i /home/james/ops_cert/inventory/misc/pr/dvbosljeffa01.ini
#sleep 2

#cd /home/james/ops_cert
#ansible-playbook /home/james/ops_cert/restarttomcat_dev4.yml --extra-vars "applicationVar=Appl_jeff envVar=Env_DV" -i /home/james/ops_cert/inventory/misc/pr/vavpr-web-04.ini
#sleep 32
#check_n_exit
#sleep 12
#ansible-playbook /home/james/ops_cert/mail.yml --extra-vars "applicationVar=Appl_jeff envVar=Env_DV" -i /home/james/ops_cert/inventory/misc/pr/dvbosljeffa01.ini
#sleep 2

#cd /home/james/ops_cert
#ansible-playbook /home/james/ops_cert/restarttomcat_dev4.yml --extra-vars "applicationVar=Appl_jeff envVar=Env_DV" -i /home/james/ops_cert/inventory/misc/pr/vavpr-web-05.ini
#sleep 32
#check_n_exit
#sleep 12
#ansible-playbook /home/james/ops_cert/mail.yml --extra-vars "applicationVar=Appl_jeff envVar=Env_DV" -i /home/james/ops_cert/inventory/misc/pr/dvbosljeffa01.ini
#sleep 2

cd /home/james/ops_cert
ansible-playbook /home/james/ops_cert/restarttomcat_dev4.yml --extra-vars "applicationVar=Appl_jeff envVar=Env_DV" -i /home/james/ops_cert/inventory/misc/pr/vavpr-web-06.ini
sleep 32
check_n_exit
sleep 12
ansible-playbook /home/james/ops_cert/mail.yml --extra-vars "applicationVar=Appl_jeff envVar=Env_DV" -i /home/james/ops_cert/inventory/misc/pr/dvbosljeffa01.ini
sleep 2

cd /home/james/ops_cert
ansible-playbook /home/james/ops_cert/restarttomcat_dev4.yml --extra-vars "applicationVar=Appl_jeff envVar=Env_DV" -i /home/james/ops_cert/inventory/misc/pr/vavpr-web-07.ini
sleep 32
check_n_exit
sleep 12
ansible-playbook /home/james/ops_cert/mail.yml --extra-vars "applicationVar=Appl_jeff envVar=Env_DV" -i /home/james/ops_cert/inventory/misc/pr/dvbosljeffa01.ini
#sleep 2

#rm -f /tmp/tmp_status_*
#rm -f /tmp/tmpstatusto*

exit
