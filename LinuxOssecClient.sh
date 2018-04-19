
# This script installs ossec-hids-agent and and binarydefense auto-server and
# automatically locates the server ip and registers the agent and starts services on AWS Linux 
# ossec files https://updates.atomicorp.com/installers/atomic | are in  s3://yourbucketname
# binary defense repo https://github.com/binarydefense/auto-ossec | is in  s3://yourbucketname
# EC2 instance Role required for access to S3 and EC2
# for linux client, the line with 'aws ec2 describe-instances' must have correct region
# ossec server must have AWS tag of Name=tag:Function,Values=ossecserver

#############################
####Linux OSSEC Client#######
#############################


sudo su
aws s3 cp s3://ossecconfigszoca . --recursive

chmod +x ./atomic
./atomic


yum -y install ossec-hids-agent
awk 'NR==38 {$0="logcollector.remote_commands=1"} { print }' /var/ossec/etc/internal_options.conf  >test1.conf
mv -f ./test1.conf /var/ossec/etc/internal_options.conf
#


#get ip of ossec server with tag#
aws ec2 describe-instances --region [insert your region here] --filter "Name=tag:Role,Values=OssecMaster" --query Reservations[].Instances[].PrivateIpAddress --output text >serverip

ossecserverip=$( cat serverip )
MYCUSTOMTAB='    '
str1='<server-ip>'
str2='</server-ip>'

echo "${MYCUSTOMTAB}${str1}${ossecserverip}${str2}" >line5
line5=$( cat line5 )


awk 'FNR==5{if((getline line < "line5") > 0) print line; next}1' /var/ossec/etc/ossec.conf >outfile.conf
mv -f outfile.conf /var/ossec/etc/ossec.conf

#
#/var/ossec/bin/ossec-control start
chmod +x ./auto_ossec.bin
./auto_ossec.bin $ossecserverip

/var/ossec/bin/ossec-control stop
#rm -rf /var/ossec/queue/rids/*
/var/ossec/bin/ossec-control start
#

#kicking off final restart of client so it will complete registration
sleep 15m

/var/ossec/bin/ossec-control restart

#####done!!






##### Notes / Extras 
#

https://perezbox.com/2012/10/ossec-agent-to-server-connection-issues/
https://www.alienvault.com/forums/discussion/7733/disconnected-hids-agents
/var/ossec/bin/agent_control -lc
tail -F /var/ossec/logs/ossec.log
