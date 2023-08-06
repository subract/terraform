#
# Deploy Minecraft server
#

provider "hcloud" {
  token = var.hcloud_token
}

# Deploy base resources - SSH keys, firewalls, etc.
module "base" {
  source = "../../modules/base_resources"
}

# Deploy servers
module "games1" {
  source     = "../../modules/vps"
  depends_on = [module.base]

  name  = "games1"
  image = "debian-12"
  type  = "cpx11"

  labels = {
    "fw_mc" : ""
  }
}
