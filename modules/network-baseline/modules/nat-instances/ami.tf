data "aws_ami" "this" {
  most_recent = local.ami.most_recent
  owners      = [local.ami.owner]

  filter {
    name   = "name"
    values = [local.ami.name]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
