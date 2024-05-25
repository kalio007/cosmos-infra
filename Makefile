PROJECT_DIR := $(HOME)/Desktop/cosmos-infra
TERRAFORM_DIR := $(PROJECT_DIR)/terraform
ANSIBLE_DIR := $(PROJECT_DIR)/ansible

# Default target
all: deploy

# Run Terraform and then Ansible
deploy:
	cd $(TERRAFORM_DIR) && terraform apply -auto-approve
	cd $(ANSIBLE_DIR) && ansible-playbook -i inventory/hosts.ini playbooks/setup_cosmos.yml -e 'ansible_ssh_common_args="-o StrictHostKeyChecking=no"'

# Clean up everything
clean:
	cd $(TERRAFORM_DIR) && terraform destroy -auto-approve