resource "aws_default_subnet" "default_subnet_a" {
  availability_zone = "us-east-2a"
  tags = merge(var.common_tags, {
    "Name"        = "${var.prefix}-${terraform.workspace}-subnet-a"
    "Description" = "Falcon Terraform AWS Boilerplates"
  })
}

resource "aws_default_subnet" "default_subnet_b" {
  availability_zone = "us-east-2b"
  tags = merge(var.common_tags, {
    "Name"        = "${var.prefix}-${terraform.workspace}-subnet-b"
    "Description" = "Falcon Terraform AWS Boilerplates"
  })
}

resource "aws_default_subnet" "default_subnet_c" {
  availability_zone = "us-east-2c"
  tags = merge(var.common_tags, {
    "Name"        = "${var.prefix}-${terraform.workspace}-subnet-c"
    "Description" = "Falcon Terraform AWS Boilerplates"
  })
}

resource "aws_db_subnet_group" "db_subnet" {
  name       = "${var.prefix}-${terraform.workspace}-db-subnet"
  subnet_ids = [aws_default_subnet.default_subnet_a.id, aws_default_subnet.default_subnet_b.id]

  tags = merge(var.common_tags, {
    "Name"        = "${var.prefix}-${terraform.workspace}-subnet-db"
    "Description" = "Falcon Terraform AWS Boilerplates"
  })
}
