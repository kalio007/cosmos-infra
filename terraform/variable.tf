variable "key_path" {
  description = "Path to SSH private key, without extension"
  type        = string
  default     = "~/.ssh/cosmos"
}
variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

# to create your ssh key
# ssh-keygen -t rsa -b 4096 -C "yeahthatsmyemail@gmail.com" -f ~/.ssh/cosmos