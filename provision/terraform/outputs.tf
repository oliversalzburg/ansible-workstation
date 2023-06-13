output "sandbox" {
  value = {
    fqdn         = aws_route53_record.this_a.fqdn
    ipv4_address = aws_instance.this.public_ip
    name         = random_pet.this.id
  }
}
