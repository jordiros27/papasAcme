# Configuración de la IaaS para wordpress sobre AWS

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
 
provider "aws" {
	region = "us-east-1"
	access_key = "AKIAQSD4FDSBSEKTQGLD"
	secret_key = "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"
}

resource "aws_instance" "balancer-ec2" {
	ami = "ami-026b57f3c383c2eec"
	instance_type = "t2.micro"
  key_name = aws_key_pair.ssh-public-key.key_name
  user_data = <<-EOF
	      #!/bin/bash
		    sudo yum update -y
		    sudo yum -y install httpd -y
		    sudo service httpd start
		    echo "Hello world from EC2 $(hostname -f)" > /var/www/html/index.html
		    EOF
	tags = {
		Name = "balancer-papas-acme"
	}
   vpc_security_group_ids = [aws_security_group.ssh-security.id, aws_security_group.http-security.id, aws_security_group.https-security.id]
}

resource "aws_instance" "app-ec2" {
	ami = "ami-026b57f3c383c2eec"
	instance_type = "t2.micro"
  key_name = "ssh-key"
	tags = {
		Name = "app-papas-acme"
	}
  
  provisioner "file" {
    content = "sh app-acme.sh"
    destination = "/tmp/app-acme.sh"
  }

  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("../ssh-key.pem")
    host = aws_instance.app-ec2.public_ip
  }

  vpc_security_group_ids = [aws_security_group.ssh-security.id, aws_security_group.http-security.id, aws_security_group.https-security.id]

}

resource "aws_security_group" "http-security" {
	name = "http-security-goup"
 
	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
 
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "https-security" {
	name = "https-security-goup"
 
	ingress {
		from_port = 443
		to_port = 443
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
 
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "ssh-security" {
	name = "ssh-security-goup"
 
	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
 
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_key_pair" "ssh-public-key" {
  key_name   = "ssh-public-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCIKVzFa1NQO0waKSJo0wXBGgh586y48nspiGtvRh7+XGfJYitjUa0zj/NB69GAks6gJ4Usuf2OWltHl3OYPX+xKSmYc6K5IWwkATZvxGgyMQB9CBMxzTic3F5M+BnBYuHU2nrx6Dtni9YvoDruVr/eeGuJyqkWRn1M7elX+cBRb2LykrRTF21ejSsKrkFMVTQKEROsGjrEpmT8BMv9PQbGxNUGskKfe9qrMtbm93QGOhQvyic+JMxpDk2Du/GdXYkkAzgqMMCzBcyln44yKa/vImxU3UgfSosQSP189MwdimoMnas9cnyuJqoTrOKCwjwdxgbhC3JosEt0WqJe99TV"
  }
