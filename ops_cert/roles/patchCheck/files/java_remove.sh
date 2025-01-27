#!/bin/bash
# Last modified: Wed Jan 20 13:37:16 EST 2021

# dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,Benny.Butler@navihealth.com,Chad.Binkley@navihealth.com
export dist_list=jeffrey.ames@wellsky.com
export dist_list=Nima.Sherpa@wellsky.com

ts=`date`
cd /tmp
os1=`uname -r | awk -F\el '{print $2}' | awk -F\. '{print $1}'`
# echo "$ts OS is `uname -a` " > /tmp/filbeat.log
os1=`uname -r`

service_to_chk=appdynamics
service_name=appdynamics

#  yum update --exclude=docker* -y
#   vi /etc/ssh/sshd_config
#   update-alternatives --config java
#   rpm -qa|grep jdk

yum update java-1.8.0-openjdk -y
yum update java-1.8.0-openjdk-devel.x86_64 -y
yum update java-1.8.0-openjdk-devel -y
yum update java-1.8.0-openjdk-devel.i686 -y
###   do the SOMETIMES.   sometimes this will fix the nessus issue if all else fails whichis weird   yum install java-1.8.0-openjdk-devel.i686 -y

rpm -e java-1.6.0-openjdk-devel-1:1.6.0.41-1.13.13.1.el7_3.x86_64
rpm -e java-1.6.0-openjdk-devel
rpm -e java-1.6.0-openjdk
rpm -e java-1.6.0-openjdk-devel
rpm -e java-1.6.0-openjdk
###  #########  rpm -qa|grep jdk
rpm -e jdk-1.7.0_79-fcs.x86_64
rpm -e java-1.7.0-openjdk-headless
rpm -e jdk-1.7.0_79-fcs.x86_64
rpm -e java-1.6.0-sun-1.6.0.22-1jpp.1.el6.x86_64
### this hangs sometimes   yum remove java-1.7.0-openjdk-headless-1.7.0.261-2.6.22.2.el7_8.x86_64
###  this one hangs sometimes  yum remove java-1.7.0-openjdk-1.7.0.101-2.6.6.1.el7_2.x86_64

### these 4 below hang sometimes i do manually if needed    yum remove java-1.7.0-openjdk-devel-1.7.0.101-2.6.6.1.el7_2.x86_64
rpm -e java-1.7.0-openjdk-devel-1.7.0.261-2.6.22.2.el7_8.x86_64
rpm -e java-1.7.0-openjdk-1.7.0.261-2.6.22.2.el7_8.x86_64
rpm -e java-1.7.0-openjdk-headless-1.7.0.261-2.6.22.2.el7_8.x86_64

###   sometimes you need to do this also at the end  
rpm -e jdk-1.7.0_79-fcs.x86_64
#
###   sometimes you need to do this also at the end  
rpm -e java-1.7.0-openjdk-1.7.0.101-2.6.6.1.el7_2.x86_64
rpm -e java-1.7.0-openjdk-devel-1.7.0.101-2.6.6.1.el7_2.x86_64
rpm -e java-1.7.0-openjdk-headless-1.7.0.101-2.6.6.1.el7_2.x86_64
rpm -e java-1.7.0-openjdk-1.7.0.101-2.6.6.1.el7_2.x86_64
rpm -e java-1.7.0-openjdk-headless-1.7.0.101-2.6.6.1.el7_2.x86_64

rpm -e java-1.6.0-openjdk-devel-1.6.0.41-1.13.13.1.el7_3.x86_64
rpm -e java-1.6.0-openjdk-1.6.0.41-1.13.13.1.el7_3.x86_64

yum update java-1.8.0-openjdk.x86_64 -y
#yum remove jdk1.8.0_45 -y
yum update java-1.8.0-openjdk.x86_64 -y

rm -rf /usr/lib/jvm/java-1.7.0-openjdk-1.7.0.101-2.6.6.1.el7_2.x86_64
rm -rf /usr/lib/jvm/java-1.7.0*
rm -rf /usr/share/doc/java-1.7.0-openjdk-1.7.0.261-2.6.22.2.el7_8
rm -rf /usr/share/doc/java-1.7.0*
rm -rf /usr/share/doc/java-1.7.0-openjdk-1.7.0.261-2.6.22.2.el7_8
rm -rf /usr/lib/java-1.7.0*
rm -rf /usr/share/java-1.7*
rm -rf /usr/lib/java-1.7.0
rm -rf /usr/share/java-1.7.0


rpm -qa|grep jdk > /tmp/remove_java_info

cat /tmp/remove_java_info | /bin/mail -s "Server: `hostname` java versions " jeffrey.ames@wellsky.com

rm -f /tmp/remove_java_info

exit
