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
	region = "us-east-2"
	access_key = "AKIAQSD4FDSBSEKTQGLD"
	secret_key = "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"
}

resource "aws_instance" "balancer-ec2" {
	ami = "ami-0f924dc71d44d23e2"
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
	ami = "ami-0f924dc71d44d23e2"
	instance_type = "t2.micro"
  key_name = aws_key_pair.ssh-public-key.key_name
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

resource "aws_key_pair" "ssh-key" {
  key_name   = "ssh-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCFHAJwnUMdH0JIGi9JSpdOZ2IuorxxIyDOXlUPBS3JjHjPv8eieM4d3D7NxmNBTlvl3hV8r+46z6fcFD72rGDrvG0vmoVvyNEBIcuQgZ9KwcbtjGGiHcAtDSFEWgqVkXl2KkO/0ItyGUlbndLBSW/Rx9+sChA+n+KtyihqkhkNRFDAPbag4PQNqUGprcJS8FVzubSIu/HRnfjReh7O6E6LE+yrJXX5HoMnp5FshtidBtnvmcjxoMjtc5uZPMqz39VcsiQuOpSdZdWf9aCGRLcRsEhJYcq3jmxYnOYbz0X+kapNJmVebsjWcL3NDEZ0AQmx95EpJI0oIPmAbhz+QtvL"
  }
