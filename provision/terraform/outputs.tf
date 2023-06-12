output "sandbox" {
  value = {
    name         = random_pet.sandbox.id
    ipv4_address = aws_instance.sandbox.public_ip
  }
}
