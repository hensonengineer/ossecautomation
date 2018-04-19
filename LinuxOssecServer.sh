
# This script installs ossec-hids-server and binarydefense auto-ossec listener on AWS Linux
# ossec files https://updates.atomicorp.com/installers/atomic | are in  s3://yourbucketname
# binary defense repo https://github.com/binarydefense/auto-ossec | is in  s3://yourbucketname
# EC2 instance Role required for access to S3 and EC2



###########################
####Linux OSSEC Server#####
###########################

sudo su
aws s3 cp s3://ossecconfigszoca . --recursive

chmod +x ./atomic
./atomic

sudo yum -y install ossec-hids-server


awk 'NR==5 {$0="    <email_notification>no</email_notification>"} { print }' /var/ossec/etc/ossec.conf >test.conf
mv -f ./test.conf /var/ossec/etc/ossec.conf
/var/ossec/bin/ossec-control start

pip install pycrypto
pip install pexpect

chmod +x ./auto_server.py
sudo nohup python ./auto_server.py &

!

/var/ossec/bin/ossec-control stop
#rm -rf /var/ossec/queue/rids/*
/var/ossec/bin/ossec-control start

#the first client must attempt connect within this 10 min window, increase if need be
sleep 10m

/var/ossec/bin/ossec-control restart

#####done!