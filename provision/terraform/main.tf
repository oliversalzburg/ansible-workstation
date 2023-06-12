resource "random_pet" "sandbox" {}

resource "aws_security_group" "sandbox" {
  name = "sandbox-${random_pet.sandbox.id}"

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sandbox-${random_pet.sandbox.id}"
  }
}

resource "aws_key_pair" "sandbox" {
  key_name   = "sandbox-${random_pet.sandbox.id}"
  public_key = data.local_file.id_ed25519_pub.content
}

resource "aws_instance" "sandbox" {
  ami                         = data.aws_ami_ids.debian.ids[0]
  associate_public_ip_address = true
  instance_type               = "t3a.nano"
  key_name                    = aws_key_pair.sandbox.key_name
  vpc_security_group_ids      = [aws_security_group.sandbox.id]

  tags = {
    Name = "sandbox-${random_pet.sandbox.id}"
  }
}
