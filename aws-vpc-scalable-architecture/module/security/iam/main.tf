data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [var.assume_role_service]
    }
  }
}
resource "aws_iam_role" "iam_role" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = var.tags
}
resource "aws_iam_role_policy_attachment" "managed" {
  for_each = toset(var.managed_policy_arns)

  role       = aws_iam_role.iam_role.name
  policy_arn = each.value
}
resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.role_name}-profile"
  role = aws_iam_role.iam_role.name
}