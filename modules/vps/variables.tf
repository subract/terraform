variable "name" {
  description = "VPS name"
  type        = string
}

variable "image" {
  description = "CPS starting image"
  type        = string
  default     = "debian-12"
}

variable "type" {
  description = "Hetzner VPS type"
  type        = string
}

variable "location" {
  description = "VPS data center location"
  type        = string
  default     = "hil"
}

variable "firewall_ids" {
  description = "VPS firewall ID"
  type        = list(string)
}


variable "ip_name" {
  description = "VPS IP name"
  type        = string
}

variable "ip_datacenter" {
  description = "VPS IP datacenter"
  type        = string
  default     = "hil-dc1"
}

variable "ip_autodelete" {
  description = "VPS IP autodelete"
  type        = bool
  default     = false
}
