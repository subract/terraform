terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.41.0"
    }
  }
}

variable "hcloud_token" {
  sensitive = true
}

provider "hcloud" {
  token = var.hcloud_token
}

# Create dummy SSH key - needed to prevent password auth from being enabled
# Used for root user - ansible user will use key in user-data.yml
resource "hcloud_ssh_key" "dummy" {
  name       = "dummy"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEjnOHRPSNnQSrJek/SdRkFJ3Z6XnjeI4jPr/PnxTOLC"
}



# Create firewall
resource "hcloud_firewall" "web-firewall" {
  name = "web-firewall"
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


# Create a server
resource "hcloud_server" "web1" {
  name         = "web1"
  image        = "debian-12"
  server_type  = "cpx21"
  location     = "hil"
  ssh_keys     = ["dummy"]
  firewall_ids = [hcloud_firewall.web-firewall.id]

  # Add cloud-init config
  user_data = file("user-data.yml")

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  depends_on = [
    hcloud_firewall.web-firewall,
    hcloud_ssh_key.dummy
  ]
}
