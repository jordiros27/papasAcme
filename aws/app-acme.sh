#!/bin /bash

# Prepara la instacia
sudo yum update

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
cd
cp /terraform/local/startup.sh /etc/init.d
chmod u+x,g+x,o+x /etc/init.d/startup.sh

# Reinicio de la instancia
sudo reboot