variable "key_path" {
  description = "Path to the private key file"
  type        = string
}
variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}
