###############################################################################
# VPC BASTION & APP
###############################################################################
module "vpc_bastion" {
  source = "../../modules/vpc"

  name = "bastion-vpc"
  cidr = "192.168.0.0/16"
}

module "vpc_app" {
  source = "../../modules/vpc"

  name = "app-vpc"
  cidr = "172.32.0.0/16"
}
###############################################################################
# SUBNETS PUBLIC & PRIVATE
###############################################################################
module "bastion_public_subnets" {
  source = "../../modules/subnets"

  name   = "bastion-public"
  vpc_id = module.vpc_bastion.vpc_id

  cidrs = ["192.168.1.0/24"]
  azs   = ["us-east-1a"]

  public = true
}
module "app_public_subnets" {
  source = "../../modules/subnets"

  name   = "app-public"
  vpc_id = module.vpc_app.vpc_id

  cidrs = ["172.32.1.0/24", "172.32.2.0/24"]
  azs   = ["us-east-1a", "us-east-1b"]

  public = true
}
module "app_private_subnets" {
  source = "../../modules/subnets"

  name   = "app-private"
  vpc_id = module.vpc_app.vpc_id

  cidrs = ["172.32.10.0/24", "172.32.11.0/24"]
  azs   = ["us-east-1a", "us-east-1b"]

  public = false
}
###############################################################################
# INTERNET GATEWAY 
###############################################################################
module "bastion_igw" {
  source = "../../modules/internet-gateway"

  name   = "bastion-igw"
  vpc_id = module.vpc_bastion.vpc_id
}
module "app_igw" {
  source = "../../modules/internet-gateway"

  name   = "app-igw"
  vpc_id = module.vpc_app.vpc_id
}
###############################################################################
# ROUTE TABLES 
###############################################################################
module "bastion_public_rt" {
  source = "../../modules/route-tables"

  name   = "bastion-public-rt"
  vpc_id = module.vpc_bastion.vpc_id

  subnet_ids = module.bastion_public_subnets.subnet_ids

  routes = [
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = module.bastion_igw.igw_id
    }
  ]
}
module "app_public_rt" {
  source = "../../modules/route-tables"

  name   = "app-public-rt"
  vpc_id = module.vpc_app.vpc_id

  subnet_ids = module.app_public_subnets.subnet_ids

  routes = [
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = module.app_igw.igw_id
    }
  ]
}
module "app_private_rt" {
  source = "../../modules/route-tables"

  name   = "app-private-rt"
  vpc_id = module.vpc_app.vpc_id

  subnet_ids = module.app_private_subnets.subnet_ids

  routes = [
    {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = module.app_nat.nat_gateway_id
    }
  ]
}
###############################################################################
# NAT GATEWAY 
###############################################################################
module "app_nat" {
  source = "../../modules/nat-gateway"

  name      = "app-nat"
  subnet_id = module.app_public_subnets.subnet_ids[0]
}
###############################################################################
# TRANSIT GATEWAY 
###############################################################################
module "transit_gateway" {
  source = "../../modules/transit-gateway"

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
}
###############################################################################
# BASTION HOST
###############################################################################
data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

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
  key_name           = "sua-keypair"
  associate_public_ip = true
  allocate_eip        = true
}