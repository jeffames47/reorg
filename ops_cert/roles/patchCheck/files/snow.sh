#!/bin/bash
# Last modified: Mon Feb  1 14:09:15 EST 2021
# dist_list=operations@navihealth.com
# dist_list=BMW.Suwannakat@navihealth.com,jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,Benny.Butler@navihealth.com,Chad.Binkley@navihealth.com
# export dist_list=jeffrey.ames@navihealth.com,Luis.Arce@navihealth.com,BMW.Suwannakat@navihealth.com,Chad.Binkley@navihealth.com
export dist_list=jeffrey.ames@wellsky.com

export jversion="$(java -version 2>&1 | head -1 | cut -d'"' -f2 | sed '/^1\./s///' | cut -d'.' -f1)"
export workdir1='/opt/snow'
export workdir2='/opt/snow/NaviHealth/Linux'
export agent="$workdir2/naviHealth_snowagent-sios-6.2.3-1.x86_64.rpm"
export file_url="http://172.17.55.103/centos/odd_files_and_scripts/snow/NaviHealth.zip"
export zip_file='/opt/snow/NaviHealth.zip'
export logfile='/var/log/snow_install.log'
export thisbox="$(hostname)"

ts=`date`
#workdir2='/opt/snow/NaviHealth/Linux'
name_of_service=snow
echo "$ts $name_of_service  " > $logfile

if [[ -f $logfile ]]
then truncate -s0 $logfile
fi

if [[ $(which zip | wc -l) -ne 1 ]]
then yum install zip -y
else
echo "zip is installed" | tee -a $logfile
fi


if [[ ! -d $workdir1 ]]
then
  mkdir -p $workdir1
  echo -e "\n$workdir1 has been created" | tee -a $logfile
  cd $workdir1
  echo -e "\nChanging working dir to: \n$(pwd)" | tee -a $logfile
else
  echo -e "\n$workdir1 already exists" | tee -a $logfile
  cd $workdir1
fi

#if [[ $jversion -gt 5 ]]
#then echo -e "\nJava version is within acceptable limit" | tee -a $logfile
#else
#  echo "Java version needs to be updated" | tee -a $logfile
#  echo "Installing Java 8" | tee -a $logfile
#  yum install java-1.8.0-openjdk-devel -y
#fi

echo -e "\nFetching the Zip file from bnaprlopspatching01" | tee -a $logfile
curl -O $file_url | tee -a $logfile
unzip $zip_file
sleep 2

if [[ -d $workdir2 ]]
then
cd $workdir2
echo -e "\nChanging working dir to: \n$(pwd)" | tee -a $logfile
else
  echo "$workdir2 is not in expected location" | tee -a $logfile
  exit
fi
sleep 2

if [[ $(pwd) == $workdir2 ]]
then yum localinstall $agent -y | tee -a $logfile
else
  echo -e "\n\nNot in the correct directory" | tee -a $logfile
  exit
fi
sleep 2

echo -e "\nStarting Cleanup of unnessary files and folders from install" | tee -a $logfile
echo -e "\nRemoving NaviHealth folder and the zipped folder Navihealth.zip from $workdir1" | tee -a $logfile
sleep 1
rm -rf $workdir1/NaviHealth
sleep 2
rm -f $workdir1/NaviHealth.zip
sleep 2

echo -e "\nSetting up logrotate function for the scan logs." | tee -a $logfile

if [[ ! -f /etc/logrotate.d/snow ]]
then
touch /etc/logrotate.d/snow
echo "/opt/snow/data/snowagent.log {
  monthly
  rotate 24
  notifempty
  delaycompress
  copytruncate
  compress
}" >> /etc/logrotate.d/snow
else
echo -e "The logrotate for snow exists, no need to remake the entry" | tee -a $logfile
fi

if [[ $(cat ~/.bashrc | grep alias | grep snow | wc -l) -ne 1 ]]
then
echo -e "\nAdding the lines to bashrc file" | tee -a $logfile
echo 'alias snow="/opt/snow/snowagent"' >> ~/.bashrc
  if [[ $(env | grep snow_home | wc -l) -ne 1 ]]
   then
    echo -e "\nAdding the environment variable for snow_home" | tee -a $logfile
    export snow_home="/opt/snow"
    echo "snow home has been set to $(echo $snow_home)"
  else
   echo "env variable does not need to be set" | tee -a $logfile
  fi
source ~/.bashrc
fi

if [[ $(which mailx | wc -l) -ne 1 ]]
then yum install mailx -y
else
echo "mailx is now installed" | tee -a $logfile
fi

echo "If the script didnt exit, then the installation of Snow should be complete" | tee -a $logfile

cd $workdir1
echo -e "\nWe are working from $(pwd)"
sleep 5
/opt/snow/snowagent -v test
sleep 3

cat $workdir1/data/snowagent.log | tail -5 | tee -a $logfile
# cat $logfile | mail -s "Snow Install + Test is complete on $thisbox" $dist_list

clear

cat $logfile | mail -s "Snow Install + Test is complete on `hostname` " $dist_list

exit
