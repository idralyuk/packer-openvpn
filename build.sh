#!/bin/bash
export PACKER_LOG=1

packer build \
    -var "aws_region=${AWS_REGION}" \
    -var "source_ami=${SOURCE_AMI}" \
    -var "connected_devices=${CONNECTED_DEVICES}" \
    -var "instance_type=${INSTANCE_TYPE}" \
    -var "vpc_id=${VPC_ID}" \
    -var "subnet_id=${SUBNET_ID}" \
    -var "ami_users=${AMI_USERS}" \
    openvpn-template.json
