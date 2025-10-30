resource "proxmox_virtual_environment_vm" "kairos" {
  count       = var.vm_count
  name        = "${var.vm_name_prefix}-${count.index + 1}"
  description = "Managed by Terraform"
  tags        = ["terraform", "ubuntu"]

  node_name = "homelab-proxmox-01"
  agent {
    enabled = true
  }

  stop_on_destroy = true

  startup {
    order      = "${3 + count.index}"
    up_delay   = "60"
    down_delay = "60"
  }

  cdrom {
    file_id    = "local:iso/kairos-rocky-9.6-standard-amd64-generic-v3.5.6-k0sv1.32.8_k0s.0.iso"
  }

  cpu {
    cores        = 2
    type         = "x86-64-v2-AES"
  }

  memory {
    dedicated = 2048
    floating  = 2048 # set equal to dedicated to enable ballooning
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
  }

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }

  serial_device {}
  initialization {
    user_data_file_id = proxmox_virtual_environment_file.cloud_init_userdata.id
  }
}


resource "proxmox_virtual_environment_file" "cloud_init_userdata" {
  content_type = "snippets"
  datastore_id = "local"
  node_name = "homelab-proxmox-01"

  source_raw {
    data = <<-EOF
    #cloud-config
    stages:
        initramfs:
            - name: "Setup hostname"
            hostname: "node-{{ trunc 4 .MachineID }}"
    users:
    - name: "kairos"
        groups: [ "admin", "wheel" ]
        ssh_authorized_keys:
        - github:qjoly
    debug: true
    k3s:
        enabled: true
        args:
        - --disable=traefik,servicelb
        - --write-kubeconfig-mode 0644
        - --node-taint 'node-role.kubernetes.io/control-plane=effect:NoSchedule'
    install:
        device: "/dev/sda"
        reboot: true
        poweroff: true
        auto: true
        bundles:
            -  quay.io/kairos/packages:k9s-utils-0.26.7
    kubevip:
        enabled: true
        eip: 192.168.1.10
    EOF

    file_name = "user-data-cloud-config.yaml"
  }
}