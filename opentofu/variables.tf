variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 4
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

variable "p2p_network_token" {
  description = "P2P network token for Kairos cluster communication"
  type        = string
  sensitive   = true
  default     = "b3RwOgogIGRodDoKICAgIGludGVydmFsOiAzNjAKICAgIGtleTogWmNRQTNpYWRQZWNjUW9Ud3dNc1cwbDFPcFVFa0xqZjN3d3dyOFk3NDlwOAogICAgbGVuZ3RoOiA0MwogIGNyeXB0bzoKICAgIGludGVydmFsOiAzNjAKICAgIGtleTogWm55NnNwYVB2d1pBb2Z5UmdRU3F2VWtrTnliSHB2emRmZlNZRjhvZDA1dgogICAgbGVuZ3RoOiA0Mwpyb29tOiB0clNmVGk3WjZQdVZVOGVmVzNVdm16bmlsSXBBekdqWVI3eFdZVlpoTTlYCnJlbmRlenZvdXM6IGlrRWtqemR0ajAzclYyeGFpM3B5NlA4ZkVXbUtpM1p3Q0ZQSnppN3BRaG4KbWRuczogSERla251anViTjJieDE1Y05FOTVEbW1pb3ZhUHNvQldzRXhvRUw3d3ZrTwptYXhfbWVzc2FnZV9zaXplOiAyMDk3MTUyMAo="
}

variable "kubevip_eip" {
  description = "External IP address for kubevip load balancer"
  type        = string
  default     = "192.168.1.10"
}