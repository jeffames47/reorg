#!/bin/bash
# Last modified: Wed Jan 20 13:37:16 EST 2021

# dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,Benny.Butler@navihealth.com,Chad.Binkley@navihealth.com
export dist_list=jeffrey.ames@navihealth.com

ts=`date`
cd /tmp
/etc/init.d/appdynamics-machine-agent stop

exit
