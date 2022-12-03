#!/bin/bash

name="varun"
s3_bucket="upgradvarunsatpute"

#Updating the packages
apt update -y

#Installing apache2 if not  installed
if [[ apache2 != $(dpkg --get-selections apache2 | awk '{print $1}') ]];
then
        apt install apache2 -y
fi

#Ensuring apache2 is running (even if system restarts)
running=$(systemctl status apache2 | grep active | awk '{print $3}' | tr -d '()')
if [[ running != ${running} ]];
then
        systemctl enable apache2;
fi

#Ensuring apache2 service is enabled (even if system restarts)
enabled=$(systemctl is-enabled apache2 | grep "enabled")
if [[ enabled != ${enabled} ]];
then
        systemctl enable apache2
fi

#Ensuring apache2 service is enabled (even if system restarts)
enabled=$(systemctl is-enabled apache2 | grep "enabled")
if [[ enabled != ${enabled} ]];
then
        systemctl enable apache2
fi

#Creating tar archive of apache2 access logs and errors

ts=$(date "+%d%m%Y-%H%M%S")
cd /var/log/apache2

tar -cvf /tmp/${name}-httpd-logs-${ts}.tar *.log

if [[ -f /tmp/${name}-httpd-logs-${ts}.tar ]];
then
    aws s3 cp /tmp/${name}-httpd-logs-${ts}.tar s3://${s3_bucket}/${name}-httpd-logs-${ts}.tar
fi
