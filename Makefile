# Define variables
TERRAFORM_DIR := terraform
ANSIBLE_DIR := ansible
INVENTORY_FILE := $(ANSIBLE_DIR)/inventory/hosts.ini

.PHONY: all terraform ansible clean

# Default target
all: terraform ansible

# Run Terraform commands
terraform:
	@echo "Initializing and applying Terraform..."
	cd $(TERRAFORM_DIR) && terraform init && terraform apply -auto-approve

# Run Ansible playbook
ansible:
	@echo "Running Ansible playbook..."
	cd $(ANSIBLE_DIR) && ansible-playbook -i $(INVENTORY_FILE) setup_cosmos.yml

# Clean up generated files
clean:
	@echo "Cleaning up generated files..."
	cd $(TERRAFORM_DIR) && terraform destroy -auto-approve
	rm -f $(INVENTORY_FILE)
