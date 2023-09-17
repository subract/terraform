provider "proxmox" {
  pm_api_url          = "https://lyra:8006/api2/json"
  pm_debug            = true
  pm_user             = "terraform-prov@pve"
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
}


resource "proxmox_vm_qemu" "auth" {
  name        = "auth"
  target_node = "lyra"
  vmid        = 1010
  clone       = "debian-template"
  full_clone  = false
  memory      = 2048
  cores       = 2
  agent       = 1

  vga {
    type   = "qxl"
    memory = 32
  }

  network {
    bridge = "vmbr1"
    model  = "virtio"
  }

  lifecycle {
    ignore_changes = all
  }
}
