resource "aws_ecr_repository" "this" {
  name                 = "${var.prefix}-${terraform.workspace}-image"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(var.common_tags, {
    "Name"        = "${var.prefix}-${terraform.workspace}-container-registry"
    "Description" = "Falcon Terraform AWS Boilerplates"
  })
}

data "aws_caller_identity" "current" {}

data "aws_ecr_authorization_token" "token" {
  registry_id = aws_ecr_repository.this.registry_id
}
