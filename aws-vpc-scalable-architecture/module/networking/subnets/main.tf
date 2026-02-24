resource "aws_subnet" "subnet" {
  count = length(var.cidrs)

  vpc_id                  = var.vpc_id
  cidr_block              = var.cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = var.public

  tags = merge(
    {
      Name = "${var.name}-${count.index + 1}"
    },
    var.tags
  )
}