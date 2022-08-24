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

module "ecs_service" {
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

module "autoscaling" {
  source           = "./modules/application-autoscaling"
  ecs_cluster_name = module.ecs_service.ecs_cluster_name
  ecs_service_name = module.ecs_service.ecs_service_name
  common_tags      = local.common_tags
  prefix           = var.prefix
}

# V1.1
# DONE: Create Auto Scaling
# V1.2
# TODO: Create Private Subnet
# TODO: Create RDS Postgres Instance
# V1.3
# TODO: Crate Security Group RDS Postgres
# TODO: Create Route Table
# V1.4
# TODO: Create all resources to Route53
# V1.5
# TODO: Create Application Firewall
# V1.6
# TODO: Create Cloudwatch and Logs
# V1.7
# TODO: Verify all resources
# V2.0
# TODO: If all resources is ok, create Release



