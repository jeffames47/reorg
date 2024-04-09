#!/bin/bash
# Last modified:  3/22/23
export dist_list=jeffrey.ames@wellsky.com

function checkIt()
{
 ps auxw | grep -P '\b'$1'(?!-)\b' >/dev/null
 if [ $? != 0 ]
 then
   echo $1"_it is down";
     echo "`hostname` down $service " > tmp_status_DOWN_`hostname`$service_name
     sshpass -p 'Nav1Automation2018' scp -o StrictHostKeyChecking=no tmp_status_DOWN_`hostname`$service ansible@10.10.120.199:/tmp
     echo -e "\n server: `hostname` \n $service_name $service DOWN!! " | /bin/mail -s " `hostname` $service_name $service DOWN.... " $dist_list
 else
   echo $1"-it is up";
     echo "`hostname` up $service " > tmp_status_UP_`hostname`$service_name
     sshpass -p 'Nav1Automation2018' scp -o StrictHostKeyChecking=no tmp_status_UP_`hostname`$service ansible@10.10.120.199:/tmp
     echo -e "\n server: `hostname` \n $service_name $service UP!! " | /bin/mail -s "`hostname` $service_name installed on Server: `hostname` $service_name $service is UP " $dist_list
 fi;
}

service_to_chk=beat
service_name=auditbeat

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

export service=auditbeat
export service_name=auditbeat

#checkIt "nessusd"
checkIt "auditbeat"
exit
