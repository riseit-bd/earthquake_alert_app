# fastvpn-infrastructure/main.tf

provider "aws" {
  region = var.region
}

module "fastvpn" {
  source = "./modules/fastvpn-cluster"

  region            = var.region
  server_count      = var.server_count
  instance_type     = "c5.2xlarge"
  vpn_protocols     = ["wireguard", "openvpn"]
  storage_encrypted = true
  monitoring        = true
}
