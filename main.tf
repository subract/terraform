provider "hcloud" {
  token = var.hcloud_token
}

module "web1" {
  source = "./modules/vps"

  name    = "web1"
  image   = "debian-11"
  type    = "cpx21"
  ip_name = "web1-ip"
  firewall_ids = [
    hcloud_firewall.base.id,
    hcloud_firewall.web.id
  ]

  depends_on = [
    hcloud_ssh_key.dummy,
    hcloud_firewall.base,
    hcloud_firewall.web
  ]
}

module "web2" {
  source = "./modules/vps"

  name    = "web2"
  image   = "debian-11"
  type    = "cpx21"
  ip_name = "web2-ip"
  firewall_ids = [
    hcloud_firewall.base.id,
    hcloud_firewall.web.id
  ]

  depends_on = [
    hcloud_ssh_key.dummy,
    hcloud_firewall.base,
    hcloud_firewall.web
  ]
}

# Create dummy SSH key - needed to prevent password auth from being enabled
# Used for root user - ansible user will use key in user-data.yml
resource "hcloud_ssh_key" "dummy" {
  name       = "dummy"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEjnOHRPSNnQSrJek/SdRkFJ3dummyeI4jPr/PnxTOLC"
}

# Create firewalls
resource "hcloud_firewall" "base" {
  name = "base"
  apply_to {
    # Look for servers without the label "all" - which is everything
    # TODO: Remove all dependencies and variables related to firewalls - these
    # can replace them by letting the firewall know what to apply to
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
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "25565"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "25565"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}
