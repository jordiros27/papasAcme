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

# Preparar script para reboot
sudo chmod u+x local/startup.sh
sudo cp local/startup.sh ../etc/init/d
cd ../etc/rc2.d
sudo ln -s /etc/init.d/startup.sh
sudo mv startup.sh S70test.sh

# Reinicio de la instancia
sudo reboot