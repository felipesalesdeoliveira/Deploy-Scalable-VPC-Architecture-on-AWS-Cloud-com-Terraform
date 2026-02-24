resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(
    {
      Name = "${var.name}-eip"
    },
    var.tags
  )
}
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.subnet_id

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )

  depends_on = [aws_eip.nat]
}