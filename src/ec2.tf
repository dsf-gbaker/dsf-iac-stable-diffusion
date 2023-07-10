## CORE VPC STATE
data "terraform_remote_state" "dsf" {
  backend = "s3"
  config = {
    bucket  = "dsf-terraform-state"
    key     = "core/prod/terraform.tfstate"
    region  = "us-east-1"
  }
}

## Key Pair
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "stable-diffusion" {
  key_name    = "sdkey"
  public_key  = tls_private_key.key.public_key_openssh
}

// serialize the output from the generated key pair as a pem file
resource "local_file" "ssh_key" {
  filename  = "${aws_key_pair.stable-diffusion.key_name}.pem"
  content   = tls_private_key.key.private_key_pem
}

resource "aws_instance" "stable-diffusion" {
  ami                         = var.ami
  availability_zone           = var.availability-zone
  instance_type               = var.instance-type
  subnet_id                   = data.terraform_remote_state.dsf.outputs.public_subnet_id
  key_name                    = aws_key_pair.stable-diffusion.key_name
  associate_public_ip_address = true
  instance_initiated_shutdown_behavior = "terminate"

  user_data = templatefile("./scripts/startup.tftpl", {
    datadevicename: var.ebs-data-device-name,
    fstype: var.ebs-data-fstype,
    outputdir: var.output-dir
  })
  
  vpc_security_group_ids = [
    data.terraform_remote_state.dsf.outputs.security_group_id
  ]

  root_block_device {
    volume_size           = "60" # GiB
    volume_type           = "gp2"
    delete_on_termination = true
  }
}

resource "aws_ebs_volume" "data" {
  availability_zone = var.availability-zone
  size              = var.ebs-data-size

  tags = {
    Type = "data"
  }
}

/*
resource "aws_ebs_snapshot" "data" {
  volume_id = aws_ebs_volume.data.id
}
*/

resource "aws_volume_attachment" "data" {
  device_name = var.ebs-data-device-name
  volume_id   = aws_ebs_volume.data.id
  instance_id = aws_instance.stable-diffusion.id

  stop_instance_before_detaching = true
} 