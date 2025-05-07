
module "vpc" {
  source = "../modules/vpc"
  region        = var.region
  project       = var.project
  vpc_cidr      = var.vpc_cidr 
  subnet_a_cidr = var.subnet_a_cidr
  subnet_b_cidr = var.subnet_b_cidr
}

module "ec2" {
  source             = "../modules/ec2"
  instance_type      = var.instance_type
  ami_id             = var.ami_id 
  name_prefix        = var.name_prefix
  vpc_id =  module.vpc.vpc_id
  subnet_id = module.vpc.subnet_a_id
}
