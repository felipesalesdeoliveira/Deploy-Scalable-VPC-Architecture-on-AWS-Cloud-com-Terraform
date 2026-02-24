resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  key_name                    = var.key_name
  associate_public_ip_address = var.allocate_eip ? false : var.associate_public_ip

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}

resource "aws_eip" "elastic_ip" {
  count  = var.allocate_eip ? 1 : 0
  domain = "vpc"

  tags = merge(
    {
      Name = "${var.name}-eip"
    },
    var.tags
  )
}

resource "aws_eip_association" "elastic_ip_association" {
  count         = var.allocate_eip ? 1 : 0
  instance_id   = aws_instance.bastion.id
  allocation_id = aws_eip.elastic_ip[0].id
}