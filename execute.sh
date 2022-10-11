#!/bin /bash
cd aws/
terraform init
terraform plan
terraform apply -auto-approve



