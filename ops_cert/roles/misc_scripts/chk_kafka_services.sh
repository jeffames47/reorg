#!/bin/bash
####################################################################
# This script will check to see if a service is down and restart it
# This requires input variable with the service name
# Last modified:  Thu Jun 21 15:32:24 EDT 2021  - Jeff Ames
# usage : sh service_chk_and_restart.sh <services> d=optional debug
#              - where <service> is a services to check and restart
####################################################################

######## global variables:a

hst=`hostname`
dt=`date +%m%d%y%H%M`
DIR="/tmp"
REL_DIR="/tmp"
user=`whoami`
host=`hostname -s`
host_f3=$(echo $host|cut -c1-3)
release_set=0
export up_down_bit=1
dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com
dist_list=jeffrey.ames@naviHealth.com

######## Submodules:

##############################################################
# This function will check a service and run it if it is down
##############################################################
check_service_and_run_if_down() {
    pid_count=$(ps -ef | egrep $service | egrep -v grep | wc -l)
    pid=$(ps -ef | egrep $service | awk '{print $2}')
    service_chk_centos6_wc=`ps -ef | grep $service | grep -v grep | wc -l`
    service_chk_wc=`systemctl status $service | grep active | grep running | grep running | wc -l`
    if [[ ${DEBUG} = d ]]
    then
        echo  -e  "\n In check_service_and_run_if_down   debug mode.....   service_chk_wc is: $service_chk_wc $service is: $service pid is: $pid"
    fi


    if [[ ${DEBUG} = d ]]
    then
      echo  -e  "\n In loop service_chk_wc is $service_chk_wc   service is $service"
    fi

    if [[ $service_chk_wc -lt 1 ]]
    then
        export dt_stamp=`date +%m%d%y%H%M`
        # debugging  echo -e "\n $dt_stamp $service is down!!!!!!!!! " | /bin/mail -s " 'WARNING' `date +%m%d%y%H%M` $service is down! " $dist_list
        sec_to_chk=$max_sec_to_chk+1
        if [[ $service == jenkins ]]
            then
                jenkins_start
          elif [[ $service == sshd ]]
          then
                sshd_start
          elif [[ $service == kafka-broker ]]
          then
                kafkabroker
          elif [[ $service == ntpd ]]
          then
                sleep 1
          elif [[ $service == schema-registry ]]
          then
               schemaregistry
          elif [[ $service == KafkaConnect ]]
          then
                KafkaConnect
          elif [[ $service == zookeeper ]]
          then
               zookeeper
          fi
          else
            export up_down_bit=0
            if [[ ${DEBUG} = d ]]
            then
              echo "up_down_bit is $up_down_bit"
              echo "up_down_bit is $up_down_bit"
            fi
            exit 1
               #### continue to check, service is not down.
        fi
}

##############################################################
# This function will double check is the service is up
#   if the service is not up we will get an email
##############################################################
dbl_chk() {   ### this is a check to see if service is running.  This will check for 15 seconds
sec_to_chk=$sec_to_chk+1;
max_sec_to_chk=15
while (( sec_to_chk <= max_sec_to_chk ))
  do
    sleep 1
    sec_to_chk=$sec_to_chk+1
        export service_chk_centos6_wc=`ps -ef | grep $service| grep -v grep | wc -l`
        export service_chk_wc=`systemctl status $service | grep active | grep running | grep running | wc -l`
        if [[ $service_chk_wc -gt 4 ]] ; then
        {
            dt_stamp=`date +%m%d%y%H%M`
            # echo "$dt_stamp More than 4 $service! Investigate and cancel $service immediately! "
            exit 0
        }
        fi
        if [[ $service_chk_wc -lt 1 ]] ; then
        {
            sleep 1   ########## continue checking for service
            sec_to_chk=$sec_to_chk+1
            #echo "$dt_stamp checking that $service is running. service_chk_wc is $service_chk_wc.   It still looks down!!!"
            }
        else
            {
                #### get out we're done
                #echo "$dt_stamp we're done and the service $service is running well!  Exiting now."
                sec_to_chk=$sec_to_chk+15
                echo -e "\n At $dt_stamp $service has been restarted with program $0. " | /bin/mail -s " 'INFO:' `date +%m%d%y%H%M` $service has been restarted. " $dist_list
                exit 1
            }
        fi
done
if [[ $service_chk_wc -lt 1 ]] ; then
        echo -e "\n At $dt_stamp $service is still down!!! Investigate Immediately. " | /bin/mail -s " 'WARNING' `date +%m%d%y%H%M` $service is still down. Investigate imediately!!!! " $dist_list
        exit 1
fi
}

##############################################################
# This function will start jenkins
##############################################################
jenkins_start() {
    echo -e " \n in jenkins_start restarting jenkins"
    echo -e "\n  sudo systemctl restart jenkins.service "
    dbl_chk
}

##############################################################
# This function will report on KafkaConnect
##############################################################
KafkaConnect() {
    echo -e " \n in $service"
      echo -e "\n Service $service is DOWN for server: $hst !!! " | /bin/mail -s " 'WARNING' Server: $hst The service $service is down!  Please double check it and restart. " $dist_list
    ###   add check and restart here later if needed
    ## dbl_chk
    export up_down_bit=1
    if [[ ${DEBUG} = d ]]
    then
      echo "up_down_bit is $up_down_bit"
      echo "up_down_bit is $up_down_bit"
    fi
    exit $up_down_bit
}
##############################################################
# This function will report on zookeeper
##############################################################
zookeeper() {
    echo -e " \n in $service"
      echo -e "\n Service $service is DOWN for server: $hst !!! " | /bin/mail -s " 'WARNING' Server: $hst The service $service is down!  Please double check it and restart. " $dist_list
    ###   add check and restart here later if needed
    ## dbl_chk
    export up_down_bit=1
    if [[ ${DEBUG} = d ]]
    then
      echo "up_down_bit is $up_down_bit"
    fi
    exit $up_down_bit
}
##############################################################
# This function will report on schemaregistry
##############################################################
schemaregistry() {
    echo -e " \n in $service"
      echo -e "\n Service $service is DOWN for server: $hst !!! " | /bin/mail -s " 'WARNING' Server: $hst The service $service is down!  Please double check it and restart. " $dist_list
    ###   add check and restart here later if needed
    ## dbl_chk
    export up_down_bit=1
    if [[ ${DEBUG} = d ]]
    then
      echo "up_down_bit is $up_down_bit"
    fi
    exit $up_down_bit
}
##############################################################
# This function will report on kafka services
##############################################################
kafkabroker() {
    echo -e " \n in kafkabroker"
      echo -e "\n Service $service is DOWN for server: $hst !!! " | /bin/mail -s " 'WARNING' Server: $hst The service $service is down!  Please double check it and restart. " $dist_list
    ###   add check and restart here later if needed
    ## dbl_chk
    export up_down_bit=1
    if [[ ${DEBUG} = d ]]
    then
      echo "up_down_bit is $up_down_bit"
    fi
    exit $up_down_bit
}

##############################################################
# This function will start sshd
##############################################################
sshd_start() {
    if [[ ${DEBUG} = d ]]
    then
        echo -e " \n this command is commented out for now just for testing ...  in sshd_start restarting $service with this command sh /etc/init.d/sshd start"
    fi
    # sh /etc/init.d/sshd start
    # sh /usr/sbin/sshd
    sleep 2
    dbl_chk
}

############################ main #################################

dt_stamp=`date +%m%d%y%H%M`
service_file=$1
service=$1
export DEBUG=$2

if [[ ${DEBUG} = d ]]
then
    echo  -e  "\n In main of program: $0 At: $dt_stamp and using the file: $1 "
fi

check_service_and_run_if_down

#####  if i got to here the service is down.  exit with a 1
export up_down_bit=1
if [[ ${DEBUG} = d ]]
then
  echo "up_down_bit is $up_down_bit"
fi
exit 1

if [[ ${DEBUG} = d ]]
then
    echo -e "\n `date '+%Y-%m-%d %H:%M:%S'` : At end of $0"
fi

exit 0
