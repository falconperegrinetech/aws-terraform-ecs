resource "aws_alb" "this" {
  name               = "api-load-balancer-${terraform.workspace}" # Naming our load balancer
  load_balancer_type = "application"
  internal           = false
  subnets            = [aws_default_subnet.default_subnet_a.id, aws_default_subnet.default_subnet_b.id, aws_default_subnet.default_subnet_c.id]
  # Referencing the security group
  security_groups = ["${aws_security_group.load_balancer.id}"]
}
