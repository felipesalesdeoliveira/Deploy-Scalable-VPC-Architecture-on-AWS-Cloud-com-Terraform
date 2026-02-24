resource "aws_launch_template" "launch_template" {
  name_prefix   = var.name
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = var.security_group_ids

  iam_instance_profile {
    name = var.instance_profile_name
  }

  user_data = var.user_data != null ? base64encode(var.user_data) : null

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.volume_size
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      {
        Name = var.name
      },
      var.tags
    )
  }

  tags = var.tags
}