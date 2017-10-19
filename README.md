# scaling-aws-ecs
Learn how to build and deploy a fault tolerant, scalable and load balanced AP on AWS ECS.

Scaling Docker on AWS  
https://www.udemy.com/scaling-docker-on-aws

Skills
1. Docker
2. AWS
3. AWS ECR
4. AWS ECS
5. AWS RDS
6. AWS S3
7. AWS ELB
8. AWS ElastiCache


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
## AWS Set up Resource
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

## ECS Components Resource
* [ECS Clusters](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/4-clusters.pdf)
* [ECS Container Agent](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/4-container-agent.pdf)
* [ECS Container Instances](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/4-container-instances.pdf)
* [ECS Task Definitions](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/4-task-definitions.pdf)
* [ECS Scheduler](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/4-scheduler.pdf)
* [ECS Scheduling Services](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/4-scheduling-services.pdf)
* [ECS Run Task and Start Task](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/4-starting-tasks.pdf)
* [Private Docker Registry (ECR)](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/4-private-docker-registry-ecr.pdf)
* [ECS CLI](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/4-ecs-cli.pdf)
* [Tearing down ECS Cluster](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/4-tearing-down-our-cluster.pdf)

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
  > cd deepdive
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
Run Task and Start Task
```
  > cd deepdive
  > aws ecs run-task --cluster deepdive --task-definition web --count 1 (auto select container-instance)
  > aws ecs list-tasks --cluster deepdive
  > aws ecs stop-task --cluster deepdive --task arn:aws:ecs:ap-northeast-1:2829XXXXXX:task/38890c8d-bd81-4998-be6d-527bXXXXXX
  > aws ecs list-tasks --cluster deepdive
  > aws ecs 
  > aws ecs list-container-instances --cluster deepdive
  > aws ecs start-task --cluster deepdive --task-definition web --container-instances arn:aws:ecs:ap-northeast-1:2829XXXXXX:container-instance/3233fc0a-8ba6-4698-abb4-817XXXXXX (specific select container-instance)
  > aws ecs stop-task --cluster deepdive --task arn:aws:ecs:ap-northeast-1:2829XXXXXX:task/b5d42a83-4276-46df-9cdb-0df6dXXXXXX
```
Private Docker Registry (ECR)
```
  > cd deepdive
  > aws ecr get-login --no-include-email --region ap-northeast-1 (see docker login -u AWS -p ......)
  > aws ecr create-repository --repository-name deepdive/nginx
  > aws ecr describe-repositories
  > aws ecr list-images --repository-name deepdive/nginx
  > docker pull nginx:1.9
  > docker image ls
  > docker tag nginx:1.9 2829XXXXX.dkr.ecr.ap-northeast-1.amazonaws.com/deepdive/nginx:1.9
  > docker image ls
  > docker push 2829XXXXX.dkr.ecr.ap-northeast-1.amazonaws.com/deepdive/nginx:1.9
  > aws ecr list-images --repository-name deepdive/nginx
  > aws ecs register-task-definition --cli-input-json file://web-task-definition.json
  > aws ecs run-task --cluster deepdive --task-definition web --count 1
```
![alt text](https://github.com/smalltide/scaling-aws-ecs/blob/master/img/ecr.png "ecr")

ECS CLI
```
  > https://github.com/aws/amazon­ecs­cli
  > http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_CLI_tutorial.html
  > ecs-cli images
  > ecs-cli ps --cluster deepdive
```
![alt text](https://github.com/smalltide/scaling-aws-ecs/blob/master/img/ecscli.png "ecscli")

Tearing down Our Cluster
```
  > aws ec2 terminate-instances --instance-ids i-06e2c776d59XXXXXX
  > aws s3 rm s3://ecs-deepdive --recursive
  > aws s3api delete-bucket --bucket deepdive
  > aws s3api delete-bucket --bucket ecs-deepdive
  > aws ecr delete-repository --repository-name deepdive/nginx --force
  > aws ecs delete-cluster --cluster deepdive
  > aws ecs deregister-task-definition --task-definition web
```

## Developing the Ruby on Rails Application
* [Generating a New Rails Project](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/5-generating-a-new-rails-project.pdf)
* [Running the Application Locally](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/5-running-the-application-locally.pdf)
* [Working with the Application](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/5-working-with-the-application.pdf)
* [Building the Demo Application](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/5-building-the-demo-application.pdf)


Generating a New Rails Project
```
  > cd scaling-aws-ecs
  > docker run -v "$PWD":/usr/src/app -w /usr/src/app rails:4 rails new --skip-bundle dockerzon
  > docker image ls
  > docker image rm rails (if want to delete rails image)
```
Running the Application Locally
```
  > cd dockerzon
  > docker-compose up
  > docker volume ls
  > docker network ls
  > docker container ls
  > docker exec dockerzon_dockerzon_1 rake db:reset
  > curl 127.0.0.1:8000
  > docker exec dockerzon_dockerzon_1 rake db:migrate
  > curl 127.0.0.1:8000
```
Working with the Application
```
  > cd dockerzon
  > docker-compose up
  > docker exec dockerzon_dockerzon_1 rails g model Dummy foo
  > docker exec dockerzon_dockerzon_1 rails d model Dummy
  > docker exec -it dockerzon_dockerzon_1 bash
  > ls -al
  > exit
  > docker exec -it dockerzon_dockerzon_1 rails c
  > exit
```
Building the Demo Application
```
  > cd dockerzon
  > docker-compose up
  > docker exec dockerzon_dockerzon_1 rake db:migrate
  > docker exec -it dockerzon_redis_1 redis-cli
  > KEYS *
  > GET dockerzon::cache:total_hits
  > exit
  > docker exec -it dockerzon_dockerzon_1 rails c
  > Javelin.all
  > Javelin.sum(:thrown)
  > Javelin.count
  > Javelin.all.pluck(:thrown)
  > exit
  > docker-compose down -v
```

## Preparing to Deploy Everything on AWS
* [Estimating AWS Costs Based on Facts](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/7-going-over-the-cost-spreadsheet.pdf)
* [Using and Configuring nginx](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/6-using-and-configuring-nginx.pdf)
* [Setting up an S3 Bucket](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/6-setting-up-an-s3-bucket.pdf)
* [Setting up RDS for Postgres](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/6-setting-up-rds-for-postgres.pdf)
* [Setting up ElastiCache for Redis](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/6-setting-up-elasticache-for-redis.pdf)
* [Setting up an Elastic Load Balancer](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/6-setting-up-an-elastic-load-balancer.pdf)
* [Profiling the Ruby on Rails Application](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/6-profiling-the-ruby-on-rails-application.pdf)


Using and Configuring nginx
```
  > cd nginx (revise PLACEHOLDER_VHOST in docker-entrypoint.sh)
  > docker build -t dockerzon_nginx .
  > cd dockerzon
  > docker-compose up -d (ROR APP run on 8000 port)
  > docker container ls -a
  > docker run --rm -p 80:80 --net dockerzon_default dockerzon_nginx (nginx proxy 80 to 8000 port)
  > curl 127.0.0.1:80
  > cd nginx (revise PLACEHOLDER_VHOST in docker-entrypoint.sh)
  > docker build -t dockerzon_nginx .
  > cd dockerzon 
  > docker-compose stop
```
![alt text](https://github.com/smalltide/scaling-aws-ecs/blob/master/img/nginx.png "nginx")

Setting up an S3 Bucket
```
  > aws s3api create-bucket --bucket ecs-dockerzon --region ap-northeast-1 --create-bucket-configuration LocationConstraint=ap-northeast-1
  > aws s3 ls s3://ecs-dockerzon
  > cd s3-production-ecsconfig
  > aws s3 cp ecs.config s3://ecs-dockerzon/ecs.config (upload)
  > aws s3 ls s3://ecs-dockerzon
```
Setting up RDS for Postgres
```
  > aws rds create-db-instance --engine postgres --no-multi-az --no-publicly-accessible --vpc-security-group-ids sg-c782XXXX --db-instance-class db.t2.micro --allocated-storage 20 --db-instance-identifier dockerzon-production --db-name dockerzon_production --master-username dockerzon --master-user-password XXXXXXXX
  > aws rds modify-db-instance --db-instance-identifier dockerzon-production --master-user-password XXXXXX (if forget password for revise) 
  > aws rds describe-db-instances
  > aws rds delete-db-instance --db-instance-identifier docker-production --skip-final-snapshot (if want to delete)
```
![alt text](https://github.com/smalltide/scaling-aws-ecs/blob/master/img/rds.png "rds")

Setting up ElastiCache for Redis
```
  > aws elasticache create-cache-cluster --engine redis --security-group-ids sg-c78XXXXX --cache-node-type cache.t2.micro --num-cache-nodes 1 --cache-cluster-id dockerzon-production
  > aws elasticache describe-cache-clusters
  > aws elasticache describe-cache-clusters --show-cache-node-info
  > aws elasticache delete-cache-cluster --cache-cluster-id dockerzon-production (if want to delete)
```
![alt text](https://github.com/smalltide/scaling-aws-ecs/blob/master/img/elastic-cache.png "elastic-cache")

Setting up an Elastic Load Balancer
```
  > aws ec2 describe-subnets
  > aws elb create-load-balancer --load-balancer-name dockerzon-web --listeners "Protocol=HTTP, LoadBalancerPort=80, InstanceProtocol=HTTP, InstancePort=80" --subnets subnet-a03XXXX subnet-76XXXXX --security-groups sg-c78XXXX
  > aws elb describe-load-balancers
  > aws elb modify-load-balancer-attributes --load-balancer-name dockerzon-web --load-balancer-attributes "{\"ConnectionSettings\":{\"IdleTimeout\":5}}"
  > aws elb configure-health-check --load-balancer-name dockerzon-web --health-check "Target=HTTP:80/health_check, Timeout=5, Interval=30, UnhealthyThreshold=2, HealthyThreshold=10"
  > aws elb delete-load-balancer --load-balancer-name dockerzon-web (if want to delete)
```
![alt text](https://github.com/smalltide/scaling-aws-ecs/blob/master/img/elb.png "elb")

#### Visualizing the Application's Architecture  
![alt text](https://github.com/smalltide/scaling-aws-ecs/blob/master/img/app-architecture.png "app-architecture")

Profiling the Ruby on Rails Application
```
  > cd dockerzon
  > add RAILS_ENV=production in .dockerzon.env top
  > docker-compose up -d
  > docker exec dockerzon_dockerzon_1 rake db:reset
  > curl http://127.0.0.1:8000
  > docker stats dockerzon_dockerzon_1 dockerzon_sidekiq_1
  > docker pull williamyeh/wrk
  > docker run --rm williamyeh/wrk -t10 -c50 -d10s http://<machine_ip>:8000
  > docker-compose stop
  > revise WEB_CONCURRENCY=2 in .dockerzon.env
  > docker stats dockerzon_dockerzon_1 dockerzon_sidekiq_1
  > docker run --rm williamyeh/wrk -t10 -c50 -d10s http://<machine_ip>:8000
```
![alt text](https://github.com/smalltide/scaling-aws-ecs/blob/master/img/profile-app.png "profile-app")

## Deploying Everything with Amazon ECS
* [Creating the Production Cluster](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/8-creating-the-production-cluster.pdf)
* [Creating the Private Registry Repositories](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/8-creating-the-private-registry-repositories.pdf)


#### Introduction
![alt text](https://github.com/smalltide/scaling-aws-ecs/blob/master/img/deploy1.png "deploy1")
![alt text](https://github.com/smalltide/scaling-aws-ecs/blob/master/img/deploy2.png "deploy2")

Creating the Production Cluster
```
  > cd production
  > aws ecs create-cluster --cluster-name production
  > aws s3api create-bucket --bucket ecs-dockerzon --region ap-northeast-1 --create-bucket-configuration LocationConstraint=ap-northeast-1
  > aws s3 ls s3://ecs-dockerzon
  > aws s3 cp ecs.config s3://ecs-dockerzon/ecs.config (upload)
  > aws s3 ls s3://ecs-dockerzon
```

Creating the Private Registry Repositories
```
  > aws ecr get-login --no-include-email --region ap-northeast-1
  > aws ecr create-repository --repository-name dockerzon/dockerzon
  >  aws ecr create-repository --repository-name dockerzon/nginx
  > aws ecr describe-repositories
  > docker tag dockerzon_dockerzon:latest 28XXXXXXX.dkr.ecr.ap-northeast-1.amazonaws.com/dockerzon/dockerzon:latest
  > docker push 28XXXXXXX.dkr.ecr.ap-northeast-1.amazonaws.com/dockerzon/dockerzon
  > docker tag dockerzon_nginx:latest 28XXXXXXX.dkr.ecr.ap-northeast-1.amazonaws.com/dockerzon/nginx:latest
  > docker push 28XXXXXXX.dkr.ecr.ap-northeast-1.amazonaws.com/dockerzon/nginx
```