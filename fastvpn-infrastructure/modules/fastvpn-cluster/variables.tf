variable "region" { type = string }
variable "server_count" { type = number }
variable "instance_type" { type = string }
variable "vpn_protocols" { type = list(string) }
variable "storage_encrypted" { type = bool }
variable "monitoring" { type = bool }
