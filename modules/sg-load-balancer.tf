resource "aws_security_group" "load_balancer" {
  vpc_id      = aws_default_vpc.default_vpc.id
  name        = "APPLICATION_LOAD_BALANCER"
  description = "Load Balancer Security Group"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    "Name"        = "${var.prefix}-load-balancer-security-group"
    "Description" = "Falcon Terraform AWS Boilerplates"
  })
}
