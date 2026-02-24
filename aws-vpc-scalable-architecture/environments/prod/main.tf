locals {
  project = "scalable-vpc"
  env     = "dev"

  common_tags = {
    Project = local.project
    Env     = local.env
    Owner   = "Felipe"
  }
}
###############################################################################
# VPC BASTION & APP
###############################################################################
module "vpc_bastion" {
  source = "../../modules/networking/vpc"

  name                 = "bastion-vpc"
  cidr                 = "192.168.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = local.common_tags
}

module "vpc_app" {
  source = "../../modules/networking/vpc"

  name                 = "app-vpc"
  cidr                 = "172.32.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = local.common_tags
}
###############################################################################
# SUBNETS PUBLIC & PRIVATE
###############################################################################
module "bastion_public_subnets" {
  source = "../../modules/networking/subnets"

  name   = "bastion-public"
  vpc_id = module.vpc_bastion.vpc_id

  cidrs  = ["192.168.1.0/24"]
  azs    = ["us-east-1a"]
  public = true

  tags = local.common_tags
}

module "app_public_subnets" {
  source = "../../modules/networking/subnets"

  name   = "app-public"
  vpc_id = module.vpc_app.vpc_id

  cidrs  = ["172.32.1.0/24", "172.32.2.0/24"]
  azs    = ["us-east-1a", "us-east-1b"]
  public = true

  tags = local.common_tags
}

module "app_private_subnets" {
  source = "../../modules/networking/subnets"

  name   = "app-private"
  vpc_id = module.vpc_app.vpc_id

  cidrs  = ["172.32.10.0/24", "172.32.11.0/24"]
  azs    = ["us-east-1a", "us-east-1b"]
  public = false

  tags = local.common_tags
}
###############################################################################
# INTERNET GATEWAY 
###############################################################################
module "bastion_igw" {
  source = "../../modules/networking/internet-gateway"

  name   = "bastion-igw"
  vpc_id = module.vpc_bastion.vpc_id
  tags   = local.common_tags
}

module "app_igw" {
  source = "../../modules/networking/internet-gateway"

  name   = "app-igw"
  vpc_id = module.vpc_app.vpc_id
  tags   = local.common_tags
}
###############################################################################
# ROUTE TABLES 
###############################################################################
module "bastion_public_rt" {
  source = "../../modules/networking/route-tables"

  name       = "bastion-public-rt"
  vpc_id     = module.vpc_bastion.vpc_id
  subnet_ids = module.bastion_public_subnets.subnet_ids

  routes = [
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = module.bastion_igw.igw_id
    },
    {
      cidr_block         = "172.32.0.0/16"
      transit_gateway_id = module.transit_gateway.tgw_id
    }
  ]

  tags = local.common_tags
}
module "app_public_rt" {
  source = "../../modules/networking/route-tables"

  name       = "app-public-rt"
  vpc_id     = module.vpc_app.vpc_id
  subnet_ids = module.app_public_subnets.subnet_ids

  routes = [
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = module.app_igw.igw_id
    }
  ]

  tags = local.common_tags
}
module "app_private_rt" {
  source = "../../modules/networking/route-tables"

  name       = "app-private-rt"
  vpc_id     = module.vpc_app.vpc_id
  subnet_ids = module.app_private_subnets.subnet_ids

  routes = [
    {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = module.app_nat.nat_gateway_id
    },
    {
      cidr_block         = "192.168.0.0/16"
      transit_gateway_id = module.transit_gateway.tgw_id
    }
  ]

  tags = local.common_tags
}
###############################################################################
# NAT GATEWAY 
###############################################################################
module "app_nat" {
  source = "../../modules/networking/nat-gateway"

  name      = "app-nat"
  subnet_id = module.app_public_subnets.subnet_ids[0]
  tags      = local.common_tags
}
###############################################################################
# TRANSIT GATEWAY 
###############################################################################
module "transit_gateway" {
  source = "../../modules/networking/transit-gateway"

  name = "main-tgw"

  vpc_attachments = [
    {
      name       = "bastion-attachment"
      vpc_id     = module.vpc_bastion.vpc_id
      subnet_ids = module.bastion_public_subnets.subnet_ids
    },
    {
      name       = "app-attachment"
      vpc_id     = module.vpc_app.vpc_id
      subnet_ids = module.app_private_subnets.subnet_ids
    }
  ]

  tags = local.common_tags
}
###############################################################################
# BASTION HOST
###############################################################################
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

module "bastion_host" {
  source = "../../modules/compute/bastion"

  name               = "bastion-host"
  ami_id             = data.aws_ami.amazon_linux.id
  instance_type      = "t3.micro"
  subnet_id          = module.bastion_public_subnets.subnet_ids[0]
  security_group_ids = [module.bastion_sg.security_group_id]

  key_name        = "bastion-key"
  create_key_pair = true
  public_key_path = "~/.ssh/id_rsa.pub"

  allocate_eip        = true
  associate_public_ip = false

  tags = local.common_tags
}
###############################################################################
# SECURITY GROUP - BASTION & APP
###############################################################################

module "bastion_sg" {
  source = "../../modules/security/security-groups"

  name        = "bastion-sg"
  description = "Security group for Bastion Host"
  vpc_id      = module.vpc_bastion.vpc_id

  ingress_rules = [
    {
      description = "SSH from my IP"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["179.160.221.189/32"]
    }
  ]

  egress_rules = [
    {
      description = "Allow all outbound"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "app_sg" {
  source = "../../modules/security/security-groups"

  name        = "app-sg"
  description = "Security group for application instances"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description = "Allow HTTP from internet"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow HTTPS from internet"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow SSH from bastion"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      security_groups = [module.bastion_sg.security_group_id]
    }
  ]

  egress_rules = [
    {
      description = "Allow all outbound"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
###############################################################################
# lOAD BALANCER - NLB
###############################################################################
module "app_nlb" {
  source = "../../modules/networking/nlb"

  name       = "app-nlb"
  vpc_id     = module.vpc_app.vpc_id
  subnet_ids = module.app_public_subnets.subnet_ids
  port       = 80
}
###############################################################################
# LAUNCH TEMPLATE - APP
###############################################################################
module "app_launch_template" {
  source = "../../modules/compute/launch-template"

  name               = "app-template"
  ami_id             = data.aws_ami.amazon_linux.id
  instance_type      = "t3.micro"
  security_group_ids = [module.app_sg.security_group_id]

  user_data = <<-EOF
              #!/bin/bash
              yum install -y httpd
              systemctl start httpd
              echo "App funcionando" > /var/www/html/index.html
              EOF
}
###############################################################################
# AUTOSCALING GROUP - APP
###############################################################################
module "app_asg" {
  source = "../../modules/compute/autoscaling"

  name               = "app-asg"
  min_size           = 2
  max_size           = 2
  desired_capacity   = 2
  subnet_ids         = module.app_private_subnets.subnet_ids
  launch_template_id = module.app_launch_template.launch_template_id
  target_group_arns  = [module.app_nlb.target_group_arn]
}