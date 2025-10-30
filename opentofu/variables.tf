variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 1
}

variable "vm_name_prefix" {
  description = "Prefix for VM names"
  type        = string
  default     = "kairos-cp"
}

variable "node_name" {
  description = "Proxmox node name where VMs will be created"
  type        = string
  default     = "homelab-proxmox-01"
}

variable "proxmox_password" {
  description = "Proxmox VE password"
  type        = string
  sensitive   = true
}