#!/bin/bash

# Last modified:  Tue Aug 11 16:47:19 EST 2020   added manage engine install and start.
 
dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Chad.Binkley@navihealth.com
dist_list_with_benny=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Chad.Binkley@navihealth.com,Benny.Butler@navihealth.com
#  dist_list_with_benny=jeffrey.ames@navihealth.com
#  export dist_list=jeffrey.ames@navihealth.com
destdir='/var/log/patch'
logfile='/var/log/patch/patch_log.log'
pre_flight_logfile='/var/log/patch/pre_flight.log'
pre_patch_file='/var/log/patch/pre_patch.out'
last_patch_file='/var/log/patch/last_patch.csv'
today="$(date)"
pre_flight='yum check-update'
tmpfile='/var/log/patch/tmp.out'
outfile='/var/log/patch/latest.csv'
badrepo='/etc/yum.repos.d/redhat.repo'
badrepo2='/etc/yum.repos.d/curaspan.repo'

# Create the /var/log/patch directory if it does not exist
if [[ ! -d $destdir ]];
  then mkdir -p $destdir
fi
# Create the logfile if it doesn't exist
if [ ! -f $logfile ];
  then touch $logfile
else
  echo -e "\nThe patching log exists"
fi
# Create the preflight logs
if [ ! -f $pre_flight_logfile ];
  then touch $pre_flight_logfile
else
  echo -e "\nThe pre_flight_log exists"
fi
# Create the last_patch.csv if it doesn't exist
if [ ! -f $last_patch_file ];
  then touch $last_patch_file
else
  echo -e "\nThe last_patch csv exists"
fi
# Create the pre_patch.csv if it doesn't exist
if [ ! -f $prepatchfile ];
  then touch $prepatchfile
else
  echo -e "\nThe pre_patch csv exists"
fi
# Make sure if redhat.repo exists, that it is disabled
if [ -f $badrepo ]; then
  sed -i 's/enabled\ =\ 1/enabled =\ 0/g' $badrepo
else
  echo "redhat.repo does not exist"
fi
# Make sure if curaspan.repo exists, that it is disabled
if [ -f $badrepo2 ]; then
  sed -i 's/enabled=1/enabled=0/g' $badrepo2
else
  echo "curaspan.repo does not exist"
fi
# Add the top table row of the pre_patch.csv file
echo -e "Patch_stage, Hostname, Ip Address, CentOS Version, Kernel Version, Last Patch Date \n " > $pre_patch_file
# Send the values of the table rows to the pre_patch.csv
echo -e "Pre_patch,$(hostname),$(ifconfig | grep inet | grep -v "inet6" | grep -v "127" | awk '{print$2}'),$(cat /etc/redhat-release),$(uname -r),$today" >> $pre_patch_file
# Run Pre-flight check
echo -e "\nThe following packages are scheduled to updated" >> $pre_flight_logfile
$pre_flight >> $pre_flight_logfile
# make sure yum is clean
rm -rf /var/cache/yum
if [[ -f /etc/yum.repo.d/elastic.repo ]]; then
rm -f /etc/yum.repo.d/elastic.repo
else
echo "elastic repo does not exist"
fi
yum clean all
sleep 1
yum remove subscription-manager -y
sleep 1
yum remove katello -y
sleep 3
yum update -y
sleep 3
# Send the values of the table rows to the post_patch.csv
echo "Post_patch,$(hostname),$(ifconfig | grep inet | grep -v "inet6" | grep -v "127" | awk '{print$2}'),$(cat /etc/redhat-release),$(uname -r),$(date)" >> $last_patch_file
# Notify complete
echo "The update is complete" | tee -a $logfile
# Cat both files for examination, send the output to tmp file and then to final file
cat $pre_patch_file > $tmpfile
cat $last_patch_file >> $tmpfile
mv $tmpfile $outfile
# Show the output to you
cat $outfile | column -t -s ","
# Send all the preflight info gathered via email to specified email addresses
cat $pre_flight_logfile | mail -s "$(hostname) preflight logfile" $dist_list
# Send the final output via email to specified email addresses
cat $outfile | column -t -s "," | mail -s "$(hostname) patch complete" $dist_list_with_benny

# The next bunch of code gets the ManageEngine Agent for linux
curl -O http://10.10.120.180/centos/7/files/ME/UEMSLinuxAgent.zip
sleep 2
# Install mng engine zip
yum install -y zip unzip
unzip UEMSLinuxAgent.zip
chmod +x UEMS_LinuxAgent.bin
sh UEMS_LinuxAgent.bin
systemctl start dcservice

# Send Message that reboot will happen soon.
wall "This server will reboot in 15 secs. Save your work and log off now"
# sleep 25
# reboot
exit 0
