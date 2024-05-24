variable "digitalocean_token" {
  description = "DigitalOcean API token"
  type        = string
}

variable "ssh_keys" {
  description = "List of SSH key fingerprints to be added to the Droplet"
  type        = list(string)
  default     = []
}
