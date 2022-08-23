resource "aws_ecr_repository" "this" {
  name                 = "api-ecs-test"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(local.common_tags, {
    "Name"        = "${var.prefix}-container-registry"
    "Description" = "Falcon Terraform AWS Boilerplates"
  })
}

data "aws_caller_identity" "current" {}

data "aws_ecr_authorization_token" "token" {
  registry_id = aws_ecr_repository.this.registry_id
}
