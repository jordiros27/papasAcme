#!/bin/bash

# Ejecutar terraform
cd
cd terraform/local/
mkdir execution/
terraform init 
terraform apply -auto-approve