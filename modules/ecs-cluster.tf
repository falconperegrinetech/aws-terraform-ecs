resource "aws_ecs_cluster" "this" {
  name = "api"
  tags = merge(local.common_tags, {
    "Name"        = "${var.prefix}-api-ecs-cluster"
    "Description" = "Falcon Terraform AWS Boilerplates"
  })
}
