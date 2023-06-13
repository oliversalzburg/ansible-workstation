variable "id_ed25519_pub" {
  description = "Your ~/.ssh/id_ed25519.pub"
  type        = string
}

variable "zone_name" {
  description = "The name of a public hosted zone on Route53, into which we'll register the names of sandboxes."
  type        = string
}
