terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.86.0"
    }
  }
}

provider "proxmox" {
  endpoint = "https://192.168.1.181:8006/"

  username = "root@pam"
  password = var.proxmox_password
  insecure = true
}
