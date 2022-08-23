# Providing a reference to our default VPC
resource "aws_default_vpc" "default_vpc" {
  tags = merge(var.common_tags, {
    "Name"        = "${var.prefix}-${terraform.workspace}-vpc"
    "Description" = "Falcon Terraform AWS Boilerplates"
  })
}
