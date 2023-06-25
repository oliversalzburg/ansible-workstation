output "sandbox" {
  value = {
    fqdn         = aws_route53_record.this_a.fqdn
    ipv4_address = aws_instance.this.public_ip
    name         = random_pet.this.id
    ssh_key      = aws_key_pair.this.public_key
    // Default for Debian AMI.
    ssh_username = "admin"
  }
}
