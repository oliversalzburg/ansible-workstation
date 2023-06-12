output "sandbox" {
  value = {
    name         = random_pet.this.id
    ipv4_address = aws_instance.this.public_ip
  }
}
