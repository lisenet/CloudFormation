# CloudFormation

CloudFormation templates that show examples of how Lisenet.com is configured on AWS.

Lisenet.com is a WordPress application that is built using a three-tier architecture. Well, it is a bit of a stretch to be honest with you, but bear with me.

* Presentation Tier - Cloudflare (an alternative would be AWS ELB),
* Application Tier - AWS VPCSubnetBlock1,
* Data Tier - AWS VPCSubnetBlock2.

`CF-Lisenet-VPC-EC2-TEMPLATE.json` template creates a new VPC with two subnets, configures ACL, Security Groups and two EC2 instances.

Server configuration is managed by Puppet, see the `UserData` section inside the template.

`CF-Lisenet-Flow-Log-TEMPLATE.json` template enables VPC flow logs and creates an S3 bucket to store the logs.

`upload_to_s3.sh` is a Bash script that attempts to validate a JSON template before uploading it to a specified S3 bucket.
