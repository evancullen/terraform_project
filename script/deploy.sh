#!/bin/bash

set -eou pipefail

# Set AWS credentials if not already set
if [[ -z "${AWS_ACCESS_KEY_ID}" ]]; then
    read -p "Enter AWS Access Key ID: " AWS_ACCESS_KEY_ID
fi

if [[ -z "${AWS_SECRET_ACCESS_KEY}" ]]; then
    read -p "Enter AWS Secret Access Key: " AWS_SECRET_ACCESS_KEY
fi

# Initialize Terraform
terraform init -reconfigure

# Select or create Terraform workspace
terraform workspace select default || terraform workspace new dev

# Run Terraform plan
terraform plan -lock=false

# Apply changes
terraform apply -auto-approve -lock=false

# Destroy resources
terraform destroy -auto-approve -lock=false