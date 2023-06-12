resource "random_pet" "sandbox" {}

resource "tls_private_key" "id_ed25519" {
  algorithm = "ED25519"
}

resource "local_file" "id_ed25519" {
  filename        = "id_ed25519"
  content         = tls_private_key.id_ed25519.private_key_openssh
  file_permission = 0600
}
resource "local_file" "id_ed25519_pub" {
  filename = "id_ed25519.pub"
  content  = tls_private_key.id_ed25519.public_key_openssh
  file_permission = 0644
}

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
}

resource "aws_key_pair" "sandbox" {
  key_name   = "sandbox-${random_pet.sandbox.id}"
  public_key = tls_private_key.id_ed25519.public_key_openssh
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

output "sandbox" {
  value = {
    name         = random_pet.sandbox.id
    ipv4_address = aws_instance.sandbox.public_ip
  }
}
