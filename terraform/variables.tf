# ============================================================
# Core credentials — fill in terraform.tfvars (do not commit)
# ============================================================
variable "proxmox_endpoint" {
  type        = string
  description = "Proxmox VE API URL"
  default     = "https://192.168.18.51:8006/"
}

variable "proxmox_api_token" {
  type      = string
  sensitive = true
}

variable "ssh_proxmox_key" {
  type        = string
  description = "SSH private key used to connect to all VMs and LXC containers"
  sensitive   = true
}