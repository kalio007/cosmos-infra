#!/bin/bash

# Set variables
TERRAFORM_DIR="./terraform"
ANSIBLE_DIR="./ansible"
INVENTORY_FILE="$ANSIBLE_DIR/inventory/hosts.ini"

# Ensure DIGITALOCEAN_TOKEN is set
if [ -z "$DIGITALOCEAN_TOKEN" ]; then
  echo "ERROR: DIGITALOCEAN_TOKEN is not set. Please export the token and try again."
  exit 1
fi

# Run Terraform
echo "Initializing and applying Terraform..."
cd $TERRAFORM_DIR
terraform init
terraform apply -auto-approve -var "digitalocean_token=$DIGITALOCEAN_TOKEN"

# Check if Terraform was successful
if [ $? -ne 0 ]; then
  echo "ERROR: Terraform apply failed."
  exit 1
fi

# Output the contents of the inventory file
if [ ! -f $INVENTORY_FILE ]; then
  echo "ERROR: $INVENTORY_FILE does not exist."
  exit 1
fi

echo "Contents of $INVENTORY_FILE:"
cat $INVENTORY_FILE

# Run Ansible
echo "Running Ansible playbook..."
cd $ANSIBLE_DIR
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i $INVENTORY_FILE playbooks/setup_cosmos.yml  # Replace 'setup_cosmos.yml' with your actual playbook name

# Check if Ansible was successful
if [ $? -ne 0 ]; then
  echo "ERROR: Ansible playbook execution failed."
  exit 1
fi

echo "Provisioning and configuration completed successfully."
