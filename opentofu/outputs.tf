output "vm_names" {
  description = "Names of all created VMs"
  value       = proxmox_virtual_environment_vm.kairos[*].name
}

output "vm_ids" {
  description = "IDs of all created VMs"
  value       = proxmox_virtual_environment_vm.kairos[*].vm_id
}

output "vm_ipv4_addresses" {
  description = "IPv4 addresses of all created VMs"
  value       = proxmox_virtual_environment_vm.kairos[*].ipv4_addresses
}

# Simplified network IPs (one IP per VM)
output "vm_primary_ips" {
  description = "Primary network IP for each VM"
  value = [
    for vm in proxmox_virtual_environment_vm.kairos : [
      for ip_group in vm.ipv4_addresses : ip_group[0] if length(ip_group) > 0 && ip_group[0] != "127.0.0.1"
    ][0]
  ]
}