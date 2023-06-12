provider "aws" {
  default_tags {
    tags = {
      managed_by = "ansible-workstation"
      sandbox_id = random_pet.sandbox.id
    }
  }
}
