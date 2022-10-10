#!/bin /bash

# Ejecutar terraform
mkdir terraform/
cd terraform/
git init
git pull https://github.com/jordiros27/papasAcme.git
cd local/
mkdir execution/
cp main.tf execution/
cd execution/
terraform init 
terraform apply -auto-approve