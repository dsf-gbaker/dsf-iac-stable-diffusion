## Tags
variable "owner" {
  default = "beerskunk"
  type    = string
}

variable "project-name" {
  default = "stable-diffusion"
  type    = string
}

variable "environment" {
  default = "prod"
  type    = string
}

## REGION
variable "region" {
  default = "us-east-1"
  type    = string
}