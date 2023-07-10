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

variable "availability-zone" {
  default = "us-east-1a"
  type    = string
}

## AMI
variable "ami" {
  default = "ami-0a53718c4bb3f9f22"
  type    = string
}

variable "instance-type" {
  default = "g5.2xlarge"
  type    = string
}

## EBS
variable "ebs-data-size" {
  default = 20
  type    = number
}

variable "ebs-data-type" {
  default = "gp2"
  type    = string
}

variable "ebs-data-fstype" {
  default = "xfs"
  type    = string
}

variable "ebs-data-device-name" {
  default = "/dev/xvdf"
  type    = string
}

## STABLE DIFFUSION
## The following values are passed into the User Data
## startup template for the EC2 instance and are used
## when the instance starts or reboots
variable "output-dir" {
  default = "/sdout"
  type    = string
}