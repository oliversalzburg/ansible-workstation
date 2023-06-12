data "aws_ami_ids" "debian" {
  owners      = ["136693071363"]
  filter {
    name   = "name"
    values = ["debian-11-amd64-*"]
  }
}
