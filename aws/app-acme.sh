#!/bin /bash

# Prepara la instacia
sudo yum update
sudo yum -y install git

# Instalar terraform
wget https://releases.hashicorp.com/terraform/0.14.3/terraform_0.14.3_linux_amd64.zip
sudo unzip terraform_0.14.3_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# Instalar docker
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo systemctl enable docker
sudo groupadd docker
sudo usermod -aG docker ec2-user
docker run hello-world

# Descargar archivos terraform
mkdir terraform
cd terraform/
git init
git pull https://github.com/jordiros27/papasAcme.git

# Ejecutar terraform
cd local/
mkdir execution/
cp main.tf execution/
cd execution/
terraform init 
terraform apply -auto-approve
