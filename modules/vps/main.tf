# Create a server
resource "hcloud_server" "vps" {
  name               = var.name
  image              = var.image
  server_type        = var.type
  location           = var.location
  ssh_keys           = [var.ssh_key]
  labels             = var.labels
  delete_protection  = var.delete_protection
  rebuild_protection = var.delete_protection

  # Add cloud-init config
  user_data = file("${path.module}/user-data.yml")

  public_net {
    ipv4         = hcloud_primary_ip.ip.id
    ipv6_enabled = true
  }

  depends_on = [hcloud_primary_ip.ip]
}

# Create a fixed primary IP address
resource "hcloud_primary_ip" "ip" {
  name          = "${var.name}-ip"
  datacenter    = var.ip_datacenter
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = var.ip_autodelete
}
