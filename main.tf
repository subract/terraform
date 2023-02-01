# export PM_USER="terraform-prov@pve"
# export PM_PASS="TEMPTEMP"

terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.9.11"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://lyra:8006/api2/json"
  pm_debug = true
}

resource "proxmox_vm_qemu" "debian-test" {
  name        = "debian-test"
  target_node = "lyra"
  vmid = 100
  iso         = "local:iso/debian-11.6.0-amd64-netinst.iso"
  memory = 2048
  cores = 2
  
  disk {
    type = "scsi"
    storage = "local"
    format = "qcow2"
    size = "8G"
  }

  vga {
    type = "qxl"
    memory = 32
  }

  network {
    bridge    = "vmbr1"
    model     = "virtio"
  }
}