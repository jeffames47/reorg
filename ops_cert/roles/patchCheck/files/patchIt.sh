#!/bin/bash
# Last modified: 10/20/2023
 
### distro list 
#dist_list_with_benny=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Chad.Binkley@navihealth.com,Benny.Butler@navihealth.com,,Bruce.Jackson@navihealth.com
dist_list_with_benny=jeffrey.ames@careporthealth.com
dist_list=Jeffrey.Ames@careporthealth.com

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


######## Submodules:

###########################################################
# This function will install sshpass if it does not exist
##########################################################
install_sshpass() {

  if [[ $(which sshpass | wc -l) -ne 1 ]]
    then yum install sshpass -y
  else
    sleep 1
  fi

  if [[ $(which mailx | wc -l) -ne 1 ]]
    then yum install mailx -y
  else
    sleep 1
  fi
}  ############ end install_sshpass 


############################# main ##################################


if [[ $(rpm -qa | grep yum-utils| wc -l) -lt 1 ]]
   then yum install yum-utils -y
else
   echo "No need to install yum-utils"
fi

package-cleanup --oldkernels --count=1 -y

install_sshpass

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
##### Make sure if redhat.repo exists, that it is disabled
if [ -f $badrepo ]; then
  sed -i 's/enabled\ =\ 1/enabled =\ 0/g' $badrepo
else
  echo "redhat.repo does not exist"
fi
#### Make sure if curaspan.repo exists, that it is disabled
if [ -f $badrepo2 ]; then
  sed -i 's/enabled=1/enabled=0/g' $badrepo2
else
  echo "curaspan.repo does not exist"
fi
# Add the top table row of the pre_patch.csv file
echo -e "Patch_stage, Hostname, Ip Address, CentOS Version, Kernel Version, Last Patch Date, uptime \n " > $pre_patch_file
# Send the values of the table rows to the pre_patch.csv
echo -e "Pre_patch,$(hostname),$(ifconfig | grep inet | grep -v "inet6" | grep -v "127" | awk '{print$2}'),$(cat /etc/redhat-release),$(uname -r),$today,`uptime | awk '{print $3,$4}'`" >> $pre_patch_file
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
## yum update -y
yum update --exclude=docker* -y
sleep 2
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
# Send all the preflight info gathered via email to specified email addresses and also to the pfbosltwradm01 server

echo "`hostname` `date`" > tmp_status_preflight_`hostname`
cat $pre_flight_logfile >> tmp_status_preflight_`hostname`
sshpass -p 'Nav1Automation2018' scp -o StrictHostKeyChecking=no tmp_status_preflight_`hostname` ansible@10.10.120.199:/home/SOC
cat $pre_flight_logfile | mail -s "$(hostname) preflight logfile" $dist_list

# Send the final output via email to specified email addresses and also to the pfbosltwradm01 server
echo "`hostname` `date`" > tmp_status_preflight_outfile_`hostname`
cat $outfile | column -t -s "," >> tmp_status_preflight_outfile_`hostname`
cat tmp_status_preflight_outfile_`hostname` | column -t -s "," | mail -s "$(hostname) patch complete" $dist_list_with_benny

# Send Message that reboot will happen soon.
#wall "This server will reboot in 12 secs. Save your work and log off now"
# sleep 12
# reboot
exit 0
