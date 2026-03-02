data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ssm_parameter" "ami" {
  name = var.ami_ssm_parameter
}

locals {
  name = "${var.project_name}-${var.environment}"
  azs  = slice(data.aws_availability_zones.available.names, 0, 2)
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

module "admin_vpc" {
  source = "../../modules/vpc"

  name                 = "${local.name}-admin"
  cidr_block           = var.admin_vpc_cidr
  azs                  = local.azs
  public_subnet_cidrs  = var.admin_public_subnet_cidrs
  private_subnet_cidrs = []
  single_nat_gateway   = true
  enable_flow_logs     = true
  tags                 = local.tags
}

module "app_vpc" {
  source = "../../modules/vpc"

  name                 = "${local.name}-app"
  cidr_block           = var.app_vpc_cidr
  azs                  = local.azs
  public_subnet_cidrs  = var.app_public_subnet_cidrs
  private_subnet_cidrs = var.app_private_subnet_cidrs
  single_nat_gateway   = var.single_nat_gateway
  enable_flow_logs     = true
  tags                 = local.tags
}

module "bastion" {
  source = "../../modules/bastion"

  name              = local.name
  vpc_id            = module.admin_vpc.vpc_id
  subnet_id         = module.admin_vpc.public_subnet_ids[0]
  ami_id            = data.aws_ssm_parameter.ami.value
  instance_type     = var.bastion_instance_type
  key_name          = var.bastion_key_name
  allowed_ssh_cidrs = var.bastion_allowed_ssh_cidrs
  tags              = local.tags
}

module "app_layer" {
  source = "../../modules/app-layer"

  name                      = local.name
  vpc_id                    = module.app_vpc.vpc_id
  public_subnet_ids         = module.app_vpc.public_subnet_ids
  private_subnet_ids        = module.app_vpc.private_subnet_ids
  ami_id                    = data.aws_ssm_parameter.ami.value
  instance_type             = var.app_instance_type
  min_size                  = var.app_asg_min
  max_size                  = var.app_asg_max
  desired_capacity          = var.app_asg_desired
  bastion_security_group_id = module.bastion.security_group_id
  user_data = templatefile("../../scripts/userdata.sh", {
    app_repo_url    = var.app_repo_url
    app_repo_branch = var.app_repo_branch
  })
  tags = local.tags
}

module "networking" {
  source = "../../modules/networking"

  name                          = local.name
  admin_vpc_id                  = module.admin_vpc.vpc_id
  admin_vpc_cidr                = module.admin_vpc.vpc_cidr
  admin_private_subnet_ids      = module.admin_vpc.public_subnet_ids
  admin_private_route_table_ids = [module.admin_vpc.public_route_table_id]
  app_vpc_id                    = module.app_vpc.vpc_id
  app_vpc_cidr                  = module.app_vpc.vpc_cidr
  app_private_subnet_ids        = module.app_vpc.private_subnet_ids
  app_private_route_table_ids   = module.app_vpc.private_route_table_ids
  create_route53_record         = var.create_route53_record
  route53_zone_id               = var.route53_zone_id
  route53_record_name           = var.route53_record_name
  nlb_dns_name                  = module.app_layer.nlb_dns_name
  tags                          = local.tags
}
