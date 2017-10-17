# scaling-aws-ecs
Learn how to build and deploy a fault tolerant, scalable and load balanced AP on AWS ECS.

Scaling Docker on AWS  
https://www.udemy.com/scaling-docker-on-aws

Skills
1. AWS
2. AWS ECR
3. AWS ECS
4. Docker

#### AWS Scaling  
![alt text](https://github.com/smalltide/scaling-aws-ecs/blob/master/img/aws-scaling.png "aws-scaling")

#### AWS ECS Compare with Other Services  
![alt text](https://github.com/smalltide/scaling-aws-ecs/blob/master/img/ecs1.png "ecs1")
![alt text](https://github.com/smalltide/scaling-aws-ecs/blob/master/img/ecs2.png "ecs2")
![alt text](https://github.com/smalltide/scaling-aws-ecs/blob/master/img/ecs3.png "ecs3")

Install docker, docker-machine, docker-compose on Linux
```
  > https://store.docker.com
  > https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/
  > curl -sSL https://get.docker.com/ | sh (install latest docker using script)
  > docker version
  > sudo usermod -aG docker <linux user> (add user in docker group)
  > curl -L https://github.com/docker/machine/releases/download/v0.12.2/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine && chmod +x /tmp/docker-machine && sudo cp /tmp/docker-machine /usr/local/bin/docker-machine (install docker machine)
  > docker-machine version
  > sudo -i
  > sudo curl -L 
  https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose (install docker compose)
  > chmod +x /usr/local/bin/docker-compose
  > exit
  > docker-compose version  
```
#### AWS Set up Resource
* [Getting Set up on AWS](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/3-getting-set-up-on-aws.pdf)  
* [Installing and Configuring the AWS CLI](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/3-installing-and-configuring-the-aws-cli.pdf)  
* [Creating an SSH Keypair](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/3-creating-an-ssh-keypair.pdf)  
* [Creating a Security Group](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/3-creating-a-security-group.pdf)  

Installing and Configuring the AWS CLI
```
  > sudo apt-get install curl
  > curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" 
  > unzip awscli-bundle.zip
  > sudo ./awscli-bundle/install -i /usr/local/aws -b / /usr/local/bin/aws
  > rm -rf awscli-bundle.zip awscli-bundle
  > aws --version
  > aws configure
  > aws iam list-users
```
Creating an SSH Keypair (local pc ssh can connect ec2 instance)
```
  > aws ec2 create-key-pair --key-name aws-ice --query 'KeyMaterial' --output text > ~/.ssh/aws-ice.pem
  > aws ec2 describe-key-pairs
  > aws ec2 describe-key-pairs --key-names aws-ice
  > aws ec2 delete-key-pair --key-names aws-ice (for delete)
```
Creating a Security Group (Security Group used for setting ec2 network rule)
```
  > aws ec2 create-security-group --group-name ice_sg_ap-northeast-1 --description "security group for ice on ap-northeast-1"
  > aws ec2 describe-security-groups --group-id sg-cxxxxxxx
  > aws ec2 authorize-security-group-ingress --group-id sg-cxxxxxxx --protocol tcp --port 22 --cidr 0.0.0.0/0
  > aws ec2 authorize-security-group-ingress --group-id sg-cxxxxxxx --protocol tcp --port 80 --cidr 0.0.0.0/0
  > aws ec2 authorize-security-group-ingress --group-id sg-cxxxxxxx --protocol tcp --port 5432 --cidr 0.0.0.0/0 --source-group sg-cxxxxxxx (for RDS)
  > aws ec2 authorize-security-group-ingress --group-id sg-cxxxxxxx --protocol tcp --port 6379 --cidr 0.0.0.0/0 --source-group sg-cxxxxxxx (for redis)
  > aws ec2 describe-security-groups --group-id sg-cxxxxxxx
  > aws ec2 delete-security-group --group-id sg-cxxxxxxx
```
#### Creating ECS IAM Roles (used for manage aws resource access permission)
ecsInstanceRole
![alt text](https://github.com/smalltide/scaling-aws-ecs/blob/master/img/ecs-role1.png "ecs-role1")
ecsServiceRole
![alt text](https://github.com/smalltide/scaling-aws-ecs/blob/master/img/ecs-role2.png "ecs-role2")

#### ECS Components
![alt text](https://github.com/smalltide/scaling-aws-ecs/blob/master/img/ecs-components.png "ecs-components")

#### ECS Components Resource
* [ECS Clusters](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/4-clusters.pdf)
* [ECS Container Agent](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/4-container-agent.pdf)
* [Container Instances](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/4-container-instances.pdf)
* [Task Definitions](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/4-task-definitions.pdf)
* [ECS Scheduler](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/4-scheduler.pdf)
* [ECS Scheduling Services](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/4-scheduling-services.pdf)



AWS ECS Clusters
```
  > aws ecs create-cluster --cluster-name deepdive
  > aws ecs list-clusters
  > aws ecs describe-clusters --clusters deepdive
  > aws ecs delete-cluster --cluster deepdive
  > aws ecs create-cluster --cluster-name deepdive
```
![alt text](https://github.com/smalltide/scaling-aws-ecs/blob/master/img/ecs-cluster.png "ecs-cluster")

ECS Container Agent
```
  > aws s3api create-bucket --bucket ecs-deepdive --region ap-northeast-1 --create-bucket-configuration LocationConstraint=ap-northeast-1
  > cd deepdive
  > aws s3 cp ecs.config s3://ecs-deepdive/ecs.config (upload)
  > aws s3 ls s3://ecs-deepdive
  > aws s3 cp s3://ecs-deepdive/ecs.config ecs.config (download)
```
![alt text](https://github.com/smalltide/scaling-aws-ecs/blob/master/img/container-agent.png "container-agent")

Container Instances
```
  > cd deepdive
  > aws ec2 run-instances --image-id ami-21815747 --count 1 --instance-type t2.micro --iam-instance-profile Name=ecsInstanceRole --key-name aws-ice --security-group-ids sg-xxxxxx --user-data file://copy-ecs-config-to-s3 (aws-ice mean ssh key)
  > aws ec2 describe-instance-status --instance-ids i-06e2c776d598xxxxx
  > aws ec2 get-console-output --instance-id i-06e2c776d598xxxxx
  > aws ecs list-container-instances --cluster deepdive
  > aws ecs describe-container-instances --cluster deepdive --container-instances arn:aws:ecs:ap-northeast-1:28xxxxxxx:container-instance/01cf8a5e-6952-475c-b471-xxxxxxxx
  > aws ec2 terminate-instances --instance-ids i-06e2c776d598xxxxx (for delete instance)
  > ssh -i "aws-ice.pem" ec2-user@<ec2 instance ip> (ssh login ec2 instance)
```
![alt text](https://github.com/smalltide/scaling-aws-ecs/blob/master/img/container-instance.png "container-instance")

Task Definitions
```
  > cd deepdive
  > aws ecs register-task-definition --cli-input-json file://web-task-definition.json
  > aws ecs list-task-definitions
  > aws ecs list-task-definition-families
  > aws ecs describe-task-definition --task-definition web:1
  > aws ecs register-task-definition --cli-input-json file://web-task-definition.json (see "revision": 1 to "revision": 2)
  > aws ecs list-task-definitions
  > aws ecs deregister-task-definition --task-definition web:2 (delete revision 2)
  > aws ecs list-task-definitions
  > aws ecs register-task-definition help
  > aws ecs register-task-definition --generate-cli-skeleton
```
![alt text](https://github.com/smalltide/scaling-aws-ecs/blob/master/img/task-definition1.png "task-definition1")
![alt text](https://github.com/smalltide/scaling-aws-ecs/blob/master/img/task-definition2.png "task-definition2")

ECS Scheduler  
![alt text](https://github.com/smalltide/scaling-aws-ecs/blob/master/img/scheduler1.png "scheduler1")
![alt text](https://github.com/smalltide/scaling-aws-ecs/blob/master/img/scheduler2.png "scheduler2")
![alt text](https://github.com/smalltide/scaling-aws-ecs/blob/master/img/scheduler3.png "scheduler3")
![alt text](https://github.com/smalltide/scaling-aws-ecs/blob/master/img/scheduler4.png "scheduler4")
![alt text](https://github.com/smalltide/scaling-aws-ecs/blob/master/img/scheduler5.png "scheduler5")

Scheduling Services
```
  > aws ecs create-service --cluster deepdive --service-name web --task-definition web --desired-count 1 (create 1 web service)
  > aws ecs list-services --cluster deepdive
  > aws ecs describe-services --cluster deepdive --services web
  > aws ec2 describe-instances (find Public DNS)
  > aws ecs update-service --cluster deepdive --service web --task-definition web --desired-count 2 (update web service to 2 instance)
  > aws ecs describe-services --cluster deepdive --services web (see only 1 runningCount, because the port 80 in used)
  > aws ecs update-service --cluster deepdive --service web --task-definition web --desired-count 0 (remove all task)
  > aws ecs delete-service --cluster deepdive --service web (delete web service)
  > aws ecs list-services --cluster deepdive
  > aws ecs create-service --generate-cli-skeleton
```