# modules/fastvpn-cluster/main.tf

resource "aws_instance" "vpn_server" {
  count         = var.server_count
  ami           = "ami-0c55b159cbfafe1f0" # Ubuntu 22.04 LTS (Placeholder)
  instance_type = var.instance_type

  tags = {
    Name = "fastvpn-node-${count.index}"
    Role = "vpn-gateway"
  }

  # In a real scenario, we would use user_data or Ansible to install WireGuard
}

resource "aws_security_group" "vpn_sg" {
  name        = "fastvpn-sg"
  description = "Allow VPN traffic"

  ingress {
    from_port   = 51820
    to_port     = 51820
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
