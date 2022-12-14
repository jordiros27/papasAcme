#!/bin /bash
cd aws/
terraform init
terraform plan
terraform apply -auto-approve
terraform output > ip.txt
sed -i '' 's/private_ip_app = //' ip.txt
sed -i '' 's+"++' ip.txt
sed -i '' 's+"++' ip.txt
cd ..
IP=$(cat aws/ip.txt)
sed -i '' 's+ipApp+'"$IP"'+' nginx/nginx.conf
git add nginx
git commit -m "Dirección IP app actualizada"
git push