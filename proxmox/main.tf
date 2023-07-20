terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.11"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://lyra:8006/api2/json"
  pm_debug   = true
  pm_user    = "terraform-prov@pve"
}

resource "proxmox_vm_qemu" "debian-test" {
  name        = "debian-test"
  target_node = "lyra"
  vmid        = 200
  iso         = "local:iso/debian-11.6.0-amd64-netinst.iso"
  memory      = 2048
  cores       = 2

  ciuser  = "ansible"
  sshkeys = var.ssh_key

  disk {
    type    = "scsi"
    storage = "local"
    format  = "qcow2"
    size    = "8G"
  }

  vga {
    type   = "qxl"
    memory = 32
  }

  network {
    bridge = "vmbr1"
    model  = "virtio"
  }
}

resource "proxmox_vm_qemu" "vyos" {
  name        = "vyos"
  target_node = "lyra"
  vmid        = 100
  clone       = "vyos-template"
  memory      = 2048
  cores       = 2
  agent       = 1

  vga {
    type   = "qxl"
    memory = 32
  }

  disk {
    type    = "scsi"
    storage = "local"
    volume  = "local:100/vm-100-disk-0.qcow2"
    size    = "10G"
  }

  network {
    bridge = "vmbr0"
    model  = "virtio"
    tag    = 1
  }

  network {
    bridge = "vmbr1"
    model  = "virtio"
  }
}
