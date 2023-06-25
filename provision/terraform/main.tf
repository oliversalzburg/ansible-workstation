resource "random_pet" "this" {}

resource "aws_security_group" "this" {
  name = "sandbox-${random_pet.this.id}"

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
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
    Name = "sandbox-${random_pet.this.id}"
  }
}

resource "aws_key_pair" "this" {
  key_name   = "sandbox-${random_pet.this.id}"
  public_key = chomp(data.local_file.id_ed25519_pub.content)
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami_ids.debian.ids[0]
  associate_public_ip_address = true
  ebs_optimized               = true
  instance_type               = "t3.micro"
  ipv6_address_count          = 1
  key_name                    = aws_key_pair.this.key_name
  monitoring                  = true
  vpc_security_group_ids      = [aws_security_group.this.id]

  tags = {
    Name = "sandbox-${random_pet.this.id}"
  }
}

resource "aws_route53_record" "this_a" {
  name    = random_pet.this.id
  records = [aws_instance.this.public_ip]
  ttl     = 300
  type    = "A"
  zone_id = data.aws_route53_zone.sandboxes.zone_id
}
resource "aws_route53_record" "this_aaaa" {
  name    = random_pet.this.id
  records = aws_instance.this.ipv6_addresses
  ttl     = 300
  type    = "AAAA"
  zone_id = data.aws_route53_zone.sandboxes.zone_id
}
