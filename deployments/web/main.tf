#
# Deploy prod servers
#

provider "hcloud" {
  token = var.hcloud_token
}

# Deploy base resources - SSH keys, firewalls, etc.
module "base" {
  source = "../../modules/base_resources"
}

# Deploy servers
module "web1" {
  source     = "../../modules/vps"
  depends_on = [module.base]

  name  = "web1"
  image = "debian-11"
  type  = "cpx21"

  labels = {
    "fw_web" : ""
  }
}
