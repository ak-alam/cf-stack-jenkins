#!/bin/bash

#Create and update vpc stack using aws cli

aws cloudformation describe-stacks --stack-name akbar-vpc --output text &>err
# stack_not_exist=`cat err | awk '{print $2}'`
# echo $stack_not_exist
stack_not_exist=`cat err | grep -E 'error' | awk '{print $2}'`
update_stack=`cat err | grep -E 'CREATE_COMPLETE' | awk '{print $9}'`
if [[  "$stack_not_exist"  == "error" ]]; then
    echo "pass"
  aws cloudformation create-stack --stack-name akbar-vpc \
    --template-body file:///home/akbar/cloudformationTemp/cf-stack-jenkins/vpc.yaml \
    --parameters ParameterKey=EnvParam,ParameterValue=test ParameterKey=VpcCIDR,ParameterValue=10.0.0.0/16 \
        ParameterKey=PublicSubnet1CIDR,ParameterValue=10.0.1.0/24 ParameterKey=PrivateSubnet1CIDR,ParameterValue=10.0.3.0/24

elif [[ "$update_stack" == "CREATE_COMPLETE" ]]; then
    aws cloudformation update-stack --stack-name akbar-vpc \
    --template-body file:///home/akbar/cloudformationTemp/cf-stack-jenkins/vpc.yaml \
    --parameters ParameterKey=EnvParam,ParameterValue=test ParameterKey=PublicSubnet2CIDR,ParameterValue=10.0.2.0/24 \
         ParameterKey=PrivateSubnet2CIDR,ParameterValue=10.0.4.0/24
else
    aws cloudformation delete-stack --stack-name akbar-vpc
fi


# aws cloudformation describe-stacks --stack-name akbar-vpc --output text | grep -E 'CREATE_COMPLETE' | awk '{print $9}'