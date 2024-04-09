#!/bin/bash
# Last modified: Thu Jan 21 13:37:16 EST 2021

export dist_list=jeffrey.ames@navihealth.com
ts=`date`
debug=$1
os1=$(grep -Eo '[0-9]{1,4}' /etc/redhat-release|head -n1)


        case $os1 in
                5)      echo -e "\n OS is 5"
                        cp /tmp/appdynamics-machine-agent.service-6 /etc/sysconfig/appdynamics-machine-agent
                        /etc/init.d/appdynamics-machine-agent restart
                        echo
                        ;;
                6)      echo -e "\n OS is 6"
                        cp /tmp/appdynamics-machine-agent.service-6 /etc/sysconfig/appdynamics-machine-agent
                        /etc/init.d/appdynamics-machine-agent restart
                        echo
                        ;;
                7)      echo -e "\n OS is 7 so copy a file and run a command and do some other junk" | tee -a $logfile
                        cp /tmp/appdynamics-machine-agent.service-7 /etc/systemd/system/appdynamics-machine-agent.service
                        systemctl daemon-reload
                        sleep 2
                        systemctl restart appdynamics-machine-agent.service
                        echo
                        ;;
                *)      echo -e "\nInvalid" | tee -a $logfile
                        ;;
        esac
    shift `expr $OPTIND - 1`


#cleanup
# rm -f /tmp/*appd*

exit 
