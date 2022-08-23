# NETWORK
module "vpc" {
  source      = "./modules/network/vpc"
  common_tags = local.common_tags
  prefix      = var.prefix
}

module "subnets" {
  source      = "./modules/network/subnets"
  common_tags = local.common_tags
  prefix      = var.prefix
}

# IAM
module "iam" {
  source = "./modules/iam"
  prefix = var.prefix
}

# SECURITY GROUPS
module "security_group" {
  source      = "./modules/security-group"
  common_tags = local.common_tags
  prefix      = var.prefix
  vpc_id      = module.vpc.vpc_id
  depends_on = [
    module.vpc
  ]
}

# ECR IMAGE
module "registry" {
  source      = "./modules/ecr-registry"
  common_tags = local.common_tags
  prefix      = var.prefix
}

# ECS LOAD BALANCER
module "load_balancer" {
  source              = "./modules/application-load-balancer"
  vpc_id              = module.vpc.vpc_id
  subnet_a_id         = module.subnets.subnet_a_id
  subnet_b_id         = module.subnets.subnet_b_id
  subnet_c_id         = module.subnets.subnet_c_id
  sg_load_balancer_id = module.security_group.load_balancer_id
  common_tags         = local.common_tags
  prefix              = var.prefix
  depends_on = [
    module.vpc,
    module.subnets,
    module.security_group
  ]

}

module "ecs_services" {
  source                    = "./modules/elastic-container-services"
  subnet_a_id               = module.subnets.subnet_a_id
  subnet_b_id               = module.subnets.subnet_b_id
  subnet_c_id               = module.subnets.subnet_c_id
  service_security_group_id = module.security_group.service_security_group_id
  ecsTaskExecutionRole      = module.iam.ecsTaskExecutionRole
  ecsTaskExecutionRole_arn  = module.iam.ecsTaskExecutionRole_arn
  repository_url            = module.registry.repository_url
  lb_target_group_arn       = module.load_balancer.lb_target_group_arn
  common_tags               = local.common_tags
  prefix                    = var.prefix

  depends_on = [
    module.subnets,
    module.security_group,
    module.iam,
    module.registry
  ]
}

