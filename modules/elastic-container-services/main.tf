resource "aws_ecs_cluster" "this" {
  name = "${var.prefix}-${terraform.workspace}-cluster"
  tags = merge(var.common_tags, {
    "Name"        = "${var.prefix}-${terraform.workspace}-ecs-cluster"
    "Description" = "Falcon Terraform AWS Boilerplates"
  })
}

resource "aws_ecs_service" "this" {
  name            = "${var.prefix}-${terraform.workspace}-ecs-service" # Naming our first service
  cluster         = aws_ecs_cluster.this.id                            # Referencing our created Cluster
  task_definition = aws_ecs_task_definition.this.arn                   # Referencing the task our service will spin up
  launch_type     = "FARGATE"
  desired_count   = 1 # Setting the number of containers to 3

  load_balancer {
    target_group_arn = var.lb_target_group_arn # Referencing our target group
    container_name   = aws_ecs_task_definition.this.family
    container_port   = 3000 # Specifying the container port
  }

  lifecycle {
    ignore_changes = [
    desired_count]
  }


  network_configuration {
    subnets          = [var.subnet_a_id, var.subnet_b_id, var.subnet_c_id]
    assign_public_ip = true                                 # Providing our containers with public IPs
    security_groups  = ["${var.service_security_group_id}"] # Setting the security group
  }

  tags = merge(var.common_tags, {
    "Name"        = "${var.prefix}-${terraform.workspace}-ecs-service"
    "Description" = "Falcon Terraform AWS Boilerplates"
  })
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.prefix}-${terraform.workspace}-task" # Naming our first task
  container_definitions    = <<DEFINITION
  [
    {
      "name": "${var.prefix}-${terraform.workspace}-task",
      "image": "${var.repository_url}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000
        }
      ],
      "environment": [
      {
        "name": "AUTHOR",
        "value": "Aristeu Roriz Neto (Peregrine Tech)"
      }
    ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = 512         # Specifying the memory our container requires
  cpu                      = 256         # Specifying the CPU our container requires
  execution_role_arn       = var.ecsTaskExecutionRole_arn

  tags = merge(var.common_tags, {
    "Name"        = "${var.prefix}-${terraform.workspace}-ecs-task"
    "Description" = "Falcon Terraform AWS Boilerplates"
  })
}


