data "aws_ami_ids" "debian" {
  owners = ["136693071363"]
  filter {
    name   = "name"
    values = ["debian-11-amd64-*"]
  }
}

data "local_file" "id_ed25519_pub" {
  filename = var.id_ed25519_pub
}
