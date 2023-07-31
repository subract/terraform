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

# Storage for game saves
resource "hcloud_volume" "games_saves" {
  name              = "game_saves"
  location          = "hil"
  size              = 20 # GB
  format            = "ext4"
  delete_protection = true
}

# Deploy servers
module "games1" {
  source     = "../../modules/vps"
  depends_on = [module.base]

  name  = "games1"
  image = "debian-12"
  type  = "ccx22"

  labels = {
    "fw_mc" : ""
  }
}

# Attach volume to server
resource "hcloud_volume_attachment" "saves_attachment" {
  volume_id = hcloud_volume.games_saves.id
  server_id = module.games1.vps_id
  automount = true
}
