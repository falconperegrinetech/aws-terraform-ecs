resource "aws_ecs_service" "this" {
  name            = "api-service"                    # Naming our first service
  cluster         = aws_ecs_cluster.this.id          # Referencing our created Cluster
  task_definition = aws_ecs_task_definition.this.arn # Referencing the task our service will spin up
  launch_type     = "FARGATE"
  desired_count   = 3 # Setting the number of containers to 3

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn # Referencing our target group
    container_name   = aws_ecs_task_definition.this.family
    container_port   = 3000 # Specifying the container port
  }

  network_configuration {
    subnets          = [aws_default_subnet.default_subnet_a.id, aws_default_subnet.default_subnet_b.id, aws_default_subnet.default_subnet_c.id]
    assign_public_ip = true                                                # Providing our containers with public IPs
    security_groups  = ["${aws_security_group.service_security_group.id}"] # Setting the security group
  }
}
