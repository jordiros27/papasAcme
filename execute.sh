#!/bin /bash
cd aws/
terraform init
terraform plan
terraform apply -auto-approve
terraform output > ip.txt
sed -i '' 's/private_ip_app = / /' ip.txt
cat ip.txt
sed -i '' 's+"+ +' ip.txt
sed -i '' 's+"+ +' ip.txt
cat ip.txt
cd ..
IP=$(cat aws/ip.txt)
sed -i '' 's+ipApp+'"$IP"'+' nginx/nginx.conf