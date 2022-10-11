#!/bin/bash

# Ejecutar terraform
cd
mkdir execution/
cd execution/
git init
git pull https://github.com/jordiros27/papasAcme.git 
cd local/
terraform init 
terraform apply -auto-approve