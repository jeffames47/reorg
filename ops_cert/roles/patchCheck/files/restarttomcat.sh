#!/bin/bash
#This script is used for deploying Splunk UF's to CTP's machines in BOS.
# Last modified: Mon Mar 13 11:43:34 EST 2023

  /etc/init.d/tomcat8 stop
  sleep 10
  mv /var/run/tomcat8/tomcat.pid /tmp
  sleep 10
  /etc/init.d/tomcat8 start
  sleep 310

exit
