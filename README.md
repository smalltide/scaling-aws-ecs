# scaling-aws-ecs
Learn how to build and deploy a fault tolerant, scalable and load balanced AP on AWS ECS.

Scaling Docker on AWS  
https://www.udemy.com/scaling-docker-on-aws

Course Resource
* [Getting Set up on AWS](https://github.com/smalltide/scaling-aws-ecs/blob/master/resource/3-getting-set-up-on-aws.pdf)  


Skills
1. AWS
2. AWS ECR
3. AWS ECS
4. Docker

#### AWS Scaling  
![alt text]#(https://github.com/smalltide/scaling-aws-ecs/blob/master/img/aws-scaling.png "aws-scaling")

#### AWS ECS Compare with Other Services  
![alt text](https://github.com/smalltide/scaling-aws-ecs/blob/master/img/ecs1.png "ecs1")
![alt text](https://github.com/smalltide/scaling-aws-ecs/blob/master/img/ecs2.png "ecs2")
![alt text](https://github.com/smalltide/scaling-aws-ecs/blob/master/img/ecs3.png "ecs3")

install docker, docker-machine, docker-compose on Linux
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