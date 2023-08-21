module "vpc" {
  source                = "../Modules/vpc"
  environment           = var.env
  cidr_value            = var.cidr_value
  az_names              = var.az_names
  public_subnet_values  = var.public_subnet_values
  private_subnet_values = var.private_subnet_values
}

module "rds" {
  source            = "../Modules/RDS"
  vpc_id            = module.vpc.vpc_id
  private_subnets   = module.vpc.private_subnets
  count             = 1
  environment       = var.env
  allocated_storage = var.allocated_storage
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  db_username       = var.db_username
  db_password       = var.db_password
}


module "ECS" {
  source            = "../Modules/ecs"
  count             = 1
  vpc_id            = module.vpc.vpc_id
  private_subnets   = module.vpc.private_subnets
  depends_on        = [module.vpc]
  environment       = var.env
  # ecs_instance_type = var.ecs_instance_type
  # ecs_ami_id        = var.ecs_ami_id
  repo_names        = var.repo_names
  user_image        = var.user_image
  poll_image        = var.poll_image
  reward_image      = var.reward_image
  blockchain_image  = var.blockchain_image
}

module "frontend" {
  source                  = "../Modules/frontend"
  count                   = 1
  environment             = var.env
  static_assets_directory = var.static_assets_directory
  default_root_object     = var.default_root_object
  origin_path             = var.origin_path
  cloudfront_description  = var.cloudfront_description
  cloudfront_description2  = var.cloudfront_description2
}

module "Instance" {
  source                = "../Modules/Instance"
  count                 = 1
  vpc_id                = module.vpc.vpc_id
  public_subnets        = module.vpc.public_subnets
  depends_on            = [module.vpc]
  environment           = var.env
  AWS_REGION            = var.AWS_REGION
  key_name              = var.key_name
  instance_type         = var.instance_type
  ami                   = var.ami
  ebs_block_device_size = var.ebs_block_device_size
  PATH_TO_PRIVATE_KEY   = var.PATH_TO_PRIVATE_KEY
  PATH_TO_PUBLIC_KEY    = var.PATH_TO_PUBLIC_KEY
  INSTANCE_USERNAME     = var.INSTANCE_USERNAME
}

terraform {
backend "s3" {
bucket = "onchain-uat-tfstate"
key = "terraform.tfstate"
region = "eu-west-2"
encrypt = true
# dynamodb_table = "terraform_state"
}
}

