resource "aws_alb" "this" {
  name               = "${var.prefix}-${terraform.workspace}-load-balancer" # Naming our load balancer
  load_balancer_type = "application"
  internal           = false
  subnets            = [var.subnet_a_id, var.subnet_b_id, var.subnet_c_id]
  # Referencing the security group
  security_groups = ["${var.sg_load_balancer_id}"]
}

resource "aws_lb_target_group" "this" {
  name        = "${var.prefix}-${terraform.workspace}-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id # Referencing the default VPC
}


resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_alb.this.arn # Referencing our load balancer
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn # Referencing our tagrte group
  }
}

