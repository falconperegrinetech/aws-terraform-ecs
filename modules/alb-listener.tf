resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_alb.this.arn # Referencing our load balancer
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn # Referencing our tagrte group
  }
}
