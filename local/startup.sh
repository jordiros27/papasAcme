#!/bin /bash

# Ejecutar terraform
cd terraform/local/
mkdir execution/
cp main.tf execution/
cd execution/
terraform init 
terraform apply -auto-approve