variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "server_count" {
  description = "Number of VPN servers to deploy"
  type        = number
  default     = 3
}
