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

variable "ssh_key" {
  description = "Root SSH key name"
  type        = string
  default     = "dummy"
}

variable "labels" {
  description = "Labels for firewalls"
  type        = map(string)
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

variable "delete_protection" {
  description = "VPS deletion protection"
  type        = bool
  default     = false
}
