########################################
# Trust Policy
########################################

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [var.assume_role_service]
    }
  }
}

########################################
# IAM Role
########################################

resource "aws_iam_role" "iam_role" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = var.tags
}

########################################
# Managed Policy Attachments
########################################

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = toset(var.managed_policy_arns)

  role       = aws_iam_role.iam_role.id
  policy_arn = each.value
}

########################################
# Inline Policy (opcional)
########################################

resource "aws_iam_role_policy" "inline" {
  count = var.inline_policy_json != null && var.inline_policy_json != "" ? 1 : 0

  name   = "${var.role_name}-inline"
  role   = aws_iam_role.iam_role.id
  policy = var.inline_policy_json
}

########################################
# Instance Profile (opcional)
########################################

resource "aws_iam_instance_profile" "instance_profile" {
  count = var.create_instance_profile ? 1 : 0

  name = "${var.role_name}-profile"
  role = aws_iam_role.iam_role.name
}