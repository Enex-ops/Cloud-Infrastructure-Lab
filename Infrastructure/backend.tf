terraform {
  backend "s3" {
    bucket       = "terraform-state-145023112872"
    key          = "global/s3/terraform.tfstate"
    region       = "ap-southeast-2"
    encrypt      = true
    use_lockfile = true
  }
}
