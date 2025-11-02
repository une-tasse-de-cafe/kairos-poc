resource "proxmox_virtual_environment_vm" "kairos" {
  count       = var.vm_count
  name        = "${var.vm_name_prefix}-${count.index + 1}"
  description = "Kairos VM ${count.index + 1}"
  tags        = ["terraform", "Kairos"]

  node_name = var.node_name
  agent {
    enabled = true
  }

  stop_on_destroy = true

  boot_order = ["scsi0", "ide3"]

  startup {
    order      = "${3 + count.index}"
    up_delay   = "60"
    down_delay = "60"
  }

  cdrom {
    file_id    = "local:iso/kairos-rocky-9.6-standard-amd64-generic-v3.5.6-k3sv1.34.1_k3s1.iso"
  }

  cpu {
    cores        = 2
    type         = "x86-64-v2-AES"
  }

  memory {
    dedicated = 3072
    floating  = 2048
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
  node_name = var.node_name

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
    install:
        reboot: true
        auto: true

    auto:
      enable: true
    
    p2p:
     network_token: "${var.p2p_network_token}"
     disable_dht: true # Disabling DHT makes co-ordination to discover nodes only in the local network
     auto:
        ha:
          enable: true
          master_nodes: 2
    kubevip:
        enabled: true
        eip: ${var.kubevip_eip}
        interface: "ens18"

    bundles:
    - targets:
      - run://quay.io/kairos/packages:kube-vip-utils-1.0.0
    EOF

    file_name = "user-data-cloud-config.yaml"
  }
}