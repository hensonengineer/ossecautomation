The LinuxOssecServer script installs ossec-hids-server and binarydefense auto-ossec listener on AWS Linux.
The ossec repo file: https://updates.atomicorp.com/installers/atomic would go in s3://yourbucketname.
The clone of binary defense repo https://github.com/binarydefense/auto-ossec would go in s3://yourbucketname.
EC2 instance Role required for access to S3 and EC2.


The LinuxOssecClient script installs ossec-hids-agent and and binarydefense auto-server and
automatically locates the server ip and registers the agent and starts services on AWS Linux.
The ossec repo file https://updates.atomicorp.com/installers/atomic | would go in s3://yourbucketname
The clone of binary defense repo https://github.com/binarydefense/auto-ossec | would in s3://yourbucketname
EC2 instance Role required for access to S3 and EC2
For linux client, the line with 'aws ec2 describe-instances' must have correct region
For ossec server must have AWS tag of Name=tag:Role,Values=OssecMaster for script to locate its IP addr
