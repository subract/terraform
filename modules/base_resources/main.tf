# Create dummy SSH key for root, needed to disable password auth
# ansible user will use key in user-data.yml
resource "hcloud_ssh_key" "dummy" {
  name       = "dummy"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEjnOHRPSNnQSrJek/SdRkFJ3dummyeI4jPr/PnxTOLC"
}

# Create firewalls
resource "hcloud_firewall" "base" {
  name = "base"
  apply_to {
    # Slight hack to apply this firwall policy to all servers: select the
    # servers _not_ matching the nonexistent label "all"
    label_selector = "!all"
  }
  rule {
    direction = "in"
    protocol  = "icmp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}


resource "hcloud_firewall" "web" {
  name = "web"
  apply_to {
    label_selector = "fw_web"
  }
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "80"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "443"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}

resource "hcloud_firewall" "minecraft" {
  name = "minecraft"
  apply_to {
    label_selector = "fw_mc"
  }
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "25560-25569"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}


resource "hcloud_firewall" "tailscale" {
  name = "tailscale"
  apply_to {
    label_selector = "!all"
  }
  rule {
    direction = "in"
    protocol  = "udp"
    port      = "41641"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}
