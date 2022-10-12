#!/bin /bash
cd aws/
terraform destroy -auto-approve
cd ..
cp nginx/copy.conf nginx/nginx.conf