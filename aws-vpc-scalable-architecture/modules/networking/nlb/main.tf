resource "aws_lb" "nlb" {
  name               = var.name
  load_balancer_type = "network"
  subnets            = var.subnet_ids

  tags = var.tags
}

resource "aws_lb_target_group" "nlb-tg" {
  name     = "${var.name}-tg"
  port     = var.port
  protocol = "TCP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "nlb-listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = var.port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb-tg.arn
  }
}